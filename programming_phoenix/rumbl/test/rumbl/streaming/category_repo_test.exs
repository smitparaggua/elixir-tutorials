defmodule Rumbl.Streaming.CategoryRepoTest do
  use Rumbl.DataCase
  alias Rumbl.Streaming.Category
  alias Category.Query

  test "alphabetical orders by name" do
    Repo.insert!(%Category{name: "c"})
    Repo.insert!(%Category{name: "a"})
    Repo.insert!(%Category{name: "b"})

    category_names =
      Category
      |> Query.alphabetical()
      |> Repo.all()
      |> IO.inspect()
      |> Enum.map(&Map.get(&1, :name))

    assert category_names == ~w(a b c)
  end
end
