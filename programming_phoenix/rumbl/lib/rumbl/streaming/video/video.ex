defmodule Rumbl.Streaming.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Streaming.{Video, Category}

  @required_fields ~w(url title description owner_id)a
  @optional_fields ~w(category_id)a
  @fields @required_fields ++ @optional_fields

  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    field :owner_id, :integer, source: :user_id
    belongs_to :category, Category

    timestamps()
  end

  @doc false
  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:category)
  end
end
