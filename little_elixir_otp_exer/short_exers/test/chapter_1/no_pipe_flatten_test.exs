defmodule Chapter1.NoPipeFlattenTest do
  use ExUnit.Case

  test "Transform [1,[[2],3]] to [9, 4, 1] with and without the pipe operator." do
    assert Chapter1.NoPipeFlatten.apply([1, [[2], 3]])
  end
end
