defmodule Rumbl.Streaming.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Streaming.{Video, Category, Annotation}

  @required_fields ~w(url title description owner_id)a
  @optional_fields ~w(category_id)a
  @fields @required_fields ++ @optional_fields

  @primary_key {:id, Rumbl.Types.Permalink, autogenerate: true}

  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    field :slug, :string
    field :owner_id, :integer, source: :user_id

    belongs_to :category, Category
    has_many :annotations, Annotation

    timestamps()
  end

  @doc false
  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> slugify_title()
    |> assoc_constraint(:category)
  end

  defp slugify_title(changeset) do
    if title = get_change(changeset, :title) do
      put_change(changeset, :slug, slugify(title))
    else
      changeset
    end
  end

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end

  defimpl Phoenix.Param do
    def to_param(%{slug: slug, id: id}) do
      "#{id}-#{slug}"
    end
  end
end
