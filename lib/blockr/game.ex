defmodule Blockr.Game do
  alias Blockr.Game.{Tetromino, Board}

  def left(board) do
    tetro = board.tetro |> Tetromino.left()
    replace_unless_collides(board, tetro)
  end

  def right(board) do
    tetro = board.tetro |> Tetromino.right()
    replace_unless_collides(board, tetro)
  end

  def turn(board) do
    tetro = board.tetro |> Tetromino.rotate_right_90()
    replace_unless_collides(board, tetro)
  end

  def fall(board) do
    tetro = board.tetro |> Tetromino.fall()

    if collides?(board, tetro) do
      crash(board)
    else
      %{board | tetro: tetro}
    end
  end

  defp replace_unless_collides(board, tetro) do
    if not collides?(board, tetro) do
      %{board | tetro: tetro}
    else
      board
    end
  end

  defp collides?(board, tetro) do
    set = tetro |> Tetromino.to_group() |> MapSet.new()
    intersection = MapSet.intersection(set, board.points)
    MapSet.size(intersection) > 0
  end

  defp crash(board) do
    board
    |> Board.detach()
    |> Board.new_tetro()
  end
end
