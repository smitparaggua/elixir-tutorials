defmodule Rumbl.Streaming do
  @moduledoc """
  The Streaming context.
  """

  import Destructure
  alias Rumbl.Repo
  alias Rumbl.Streaming.{Category, Video, Annotation}

  def videos_of_owner(owner_id) do
    Video
    |> Video.Query.owned_by(owner_id)
    |> Repo.all()
  end

  def video_of_owner!(video_id, owner_id) do
    Repo.get_by!(Video, id: video_id, owner_id: owner_id)
  end

  @doc """
  Gets a single video.

  Raises `Ecto.NoResultsError` if the Video does not exist.

  ## Examples

      iex> get_video!(123)
      %Video{}

      iex> get_video!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video!(id), do: Repo.get!(Video, id)

  @doc """
  Creates a video.

  ## Examples

      iex> create_video(%{field: value})
      {:ok, %Video{}}

      iex> create_video(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_video(attrs \\ %{}) do
    %Video{}
    |> Video.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a video.

  ## Examples

      iex> update_video(video, %{field: new_value})
      {:ok, %Video{}}

      iex> update_video(video, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Video.

  ## Examples

      iex> delete_video(video)
      {:ok, %Video{}}

      iex> delete_video(video)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video)
      %Ecto.Changeset{source: %Video{}}

  """
  def change_video(%Video{} = video) do
    Video.changeset(video, %{})
  end

  def change_video(initial_params = %{}) do
    Video
    |> struct(initial_params)
    |> Video.changeset(%{})
  end

  def get_video_by!(attrs) do
    Repo.get_by!(Video, attrs)
  end

  def number_of_videos do
    Video
    |> Video.Query.count()
    |> Repo.one()
  end

  def categories do
    import Category.Query
    Category
    |> alphabetical()
    |> names_and_ids()
    |> Repo.all()
  end

  def add_annotation(user_id, video_id, attrs) do
    d(%Annotation{user_id, video_id})
    |> Annotation.changeset(attrs)
    |> Repo.insert()
  end

  def first_annotations_of_video(video_id, limit, after_id)
  when is_integer(video_id) and is_integer(limit) do
    Annotation
    |> Annotation.Query.in_video(video_id)
    |> Annotation.Query.first(limit)
    |> Annotation.Query.after_id(after_id)
    |> Repo.all()
  end

  def annotations_with_user(annotations, list_users)
  when is_list(annotations) and is_function(list_users) do
    annotations
    |> Enum.map(&Map.get(&1, :user_id))
    |> list_users.()
    |> connect_users(annotations)
  end

  defp connect_users(users, annotations) do
    user_map = Enum.into(users, %{}, fn user -> {user.id, user} end)
    Enum.map(annotations, fn annotation ->
      user = user_map[annotation.user_id]
      Map.put(annotation, :user, user)
    end)
  end
end
