defmodule Blockr.Game.Group do
  alias Blockr.Game.{Point, Color}

  def move_down(points) do
    points |> Enum.map(&Point.move_down/1)
  end

  def move_left(points) do
    points |> Enum.map(&Point.move_left/1)
  end

  def move_right(points) do
    points |> Enum.map(&Point.move_right/1)
  end

  def move_to(points, location) do
    points |> Enum.map(&Point.move_to(&1, location))
  end

  def swap(points) do
    points |> Enum.map(&Point.swap/1)
  end

  def flip_left_to_right(points) do
    points |> Enum.map(&Point.flip_left_to_right/1)
  end

  def flip_top_to_bottom(points) do
    points |> Enum.map(&Point.flip_top_to_bottom/1)
  end

  def rotate(points, degrees) do
    points |> Enum.map(&Point.rotate(&1, degrees))
  end

  def paint(points, shape_name) do
    points |> Enum.map(&Point.paint(&1, Color.for(shape_name)))
  end
end
