defmodule Chapter1.Sum do
  def with_enum(numbers) do
    Enum.reduce(numbers, &(&1 + &2))
  end

  def with_recursion([head | tail]) do
    head + with_recursion(tail)
  end

  def with_recursion([]) do
    0
  end
end
