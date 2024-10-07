defmodule Blockr.Game.Color do
  def for(shape_name) do
    case shape_name do
      :i -> "blue"
      :z -> "red"
      :s -> "yellow"
      :t -> "green"
      :o -> "purple"
      :j -> "orange"
      :l -> "brown"
    end
  end
end
