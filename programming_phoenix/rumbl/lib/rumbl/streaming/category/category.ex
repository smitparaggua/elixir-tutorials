defmodule Rumbl.Streaming.Category do
  use Ecto.Schema

  schema "categories" do
    field :name, :string

    timestamps()
  end
end
