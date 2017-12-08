defmodule Chapter1.NoPipeFlatten do
  def apply(array) do
    Enum.map(Enum.reverse(List.flatten(array)), &(&1 * 2))
  end
end
