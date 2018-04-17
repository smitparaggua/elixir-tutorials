defmodule Rumbl.Streaming.Annotation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Streaming.Annotation


  schema "annotations" do
    field :at, :integer
    field :body, :string
    field :user_id, :id
    field :user, :string, virtual: true

    belongs_to :video, Rumbl.Streaming.Video
    timestamps()
  end

  @doc false
  def changeset(%Annotation{} = annotation, attrs) do
    annotation
    |> cast(attrs, [:body, :at, :video_id, :user_id])
    |> validate_required([:body, :at, :video_id, :user_id])
  end
end
