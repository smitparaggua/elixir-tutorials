defmodule Rumbl.Streaming.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Streaming.Video

  @required_fields ~w(url title description owner_id)
  @optional_fields ~w()

  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    field :owner_id, :integer, source: :user_id

    timestamps()
  end

  @doc false
  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, @required_fields, @optional_fields)
    |> validate_required([:url, :title, :description])
  end
end
