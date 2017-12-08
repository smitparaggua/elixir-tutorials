defmodule Chapter1.SumTest do
  use ExUnit.Case

  alias Chapter1.Sum
  
  test "sums the list with enum" do
    assert Sum.with_enum([1, 2, 3, 4, 5]) == 15
  end
  
  test "sums the list with recursion" do
    assert Sum.with_recursion([1, 2, 3, 4, 5]) == 15
  end
end
