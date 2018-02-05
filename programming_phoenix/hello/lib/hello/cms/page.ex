defmodule Hello.CMS.Page do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hello.CMS.Page


  schema "pages" do
    field :body, :string
    field :title, :string
    field :views, :integer

    timestamps()
  end

  @doc false
  def changeset(%Page{} = page, attrs) do
    page
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
