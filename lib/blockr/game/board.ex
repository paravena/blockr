defmodule Blockr.Game.Board do
  defstruct score: 0,
            tetro: nil,
            walls: [],
            points: MapSet.new([]),
            junkyard: [],
            game_over: false

  alias Blockr.Game.{Tetromino, Group}

  def new(options \\ []) do
    __struct__(options)
    |> new_tetro()
    |> add_walls()
  end

  def new_tetro(board) do
    random_name =
      [:s, :z, :l, :i, :j, :o, :t]
      |> Enum.random()

    %__MODULE__{board | tetro: Tetromino.new(name: random_name, location: {0, 3})}
  end

  defp add_walls(board) do
    walls =
      for row <- 0..21, col <- 0..11, row in [0, 21] or col in [0, 11] do
        {row, col}
      end

    %__MODULE__{board | walls: walls, points: MapSet.new(walls)}
  end

  def eat_completed_rows(board) do
    rows = Enum.group_by(board.junkyard, fn {{row, _col}, _color} -> row end)

    completed =
      rows
      |> Enum.filter(fn {_row, list} -> length(list) == 10 end)
      |> Map.new()
      |> Map.keys()

    junkyard =
      Enum.reduce(completed, rows, &eat_row/2)
      |> Map.values()
      |> List.flatten()

    junkyard_points = Enum.map(junkyard, fn {point, _color} -> point end)

    %{board | junkyard: junkyard, points: MapSet.new(board.walls ++ junkyard_points)}
  end

  defp eat_row(row_number, rows) do
    rows
    |> Map.delete(row_number)
    |> Enum.map(fn {rn, list} ->
      if row_number > rn do
        {rn + 1, move_all_down(list)}
      else
        {rn, list}
      end
    end)
    |> Map.new()
  end

  defp move_all_down(points) do
    Enum.map(points, fn {{r, c}, color} -> {{r + 1, c}, color} end)
  end

  def show(board) do
    tetro = board.tetro |> Tetromino.to_group() |> Group.paint(board.tetro.name)
    [tetro, board.walls, board.junkyard]
  end

  def detach(board) do
    points = Tetromino.to_group(board.tetro)
    colors = Group.paint(points, board.tetro.name)

    mapset = Enum.reduce(points, board.points, &MapSet.put(&2, &1))

    %{board | points: mapset, junkyard: board.junkyard ++ colors}
    |> add_score()
    |> eat_completed_rows()
    |> new_tetro()
    |> check_game_over()
  end

  def check_game_over(board) do
    # if overlaps tetro and junkyard, then end of game
    left = board.points

    right =
      board.tetro
      |> Tetromino.to_group()
      |> MapSet.new()

    overlap_size =
      MapSet.intersection(left, right)
      |> MapSet.size()

    %{board | game_over: overlap_size > 0}
  end

  def count_complete_rows(board) do
    board.junkyard
    |> Map.new()
    |> Map.keys()
    |> Enum.group_by(fn {r, _c} -> r end)
    |> Map.values()
    |> Enum.count(fn list -> length(list) == 10 end)
  end

  def add_score(board) do
    number_of_rows = count_complete_rows(board)

    score =
      cond do
        number_of_rows == 0 ->
          0

        true ->
          :math.pow(2, number_of_rows)
          |> round()
          |> Kernel.*(50)
      end

    %{board | score: score}
  end
end
