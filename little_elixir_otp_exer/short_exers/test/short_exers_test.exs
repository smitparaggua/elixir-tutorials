defmodule ShortExersTest do
  use ExUnit.Case
  doctest ShortExers

  test "greets the world" do
    assert ShortExers.hello() == :world
  end
end
