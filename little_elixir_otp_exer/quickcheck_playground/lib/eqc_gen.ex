defmodule EQCGen do
  use EQC.ExUnit

  def string_with_fixed_length(len) do
    vector(len, char())
  end

  def string_with_variable_length do
    let len <- choose(1, 10) do
      a_to_z = :lists.seq(?a, ?z)
      vector(len, oneof(a_to_z))
    end
  end

  def string_with_commas do
    let len <- choose(1, 10) do
      a_to_z = :lists.seq(?a, ?z)
      vector(len, frequency([
        {3, oneof(a_to_z)},
        {1, ?,}
      ]))
    end
  end

  def nested_list(gen) do
    sized size do
      nested_list(size, gen)
    end
  end

  defp nested_list(0, _gen) do
    []
  end

  defp nested_list(n, gen) do
    lazy do
      oneof [
        [gen | nested_list(n-1, gen)],
        [nested_list(n-1, gen)]
      ]
    end
  end
end
