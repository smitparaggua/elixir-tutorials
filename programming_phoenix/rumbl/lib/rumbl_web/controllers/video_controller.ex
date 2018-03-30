defmodule RumblWeb.VideoController do
  use RumblWeb, :controller

  alias Rumbl.Streaming

  plug :load_categories when action in [:new, :create, :edit, :update]

  def index(conn, _params, %{id: user_id}) do
    videos = Streaming.videos_of_owner(user_id)
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params, %{id: user_id}) do
    changeset = Streaming.change_video(%{owner_id: user_id})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}, %{id: user_id}) do
    video_params = Map.put(video_params, "owner_id", user_id)
    case Streaming.create_video(video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, %{id: user_id}) do
    video = Streaming.video_of_owner!(id, user_id)
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}, %{id: user_id}) do
    video = Streaming.video_of_owner!(id, user_id)
    changeset = Streaming.change_video(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, %{id: user_id}) do
    video = Streaming.video_of_owner!(id, user_id)

    case Streaming.update_video(video, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, %{id: user_id}) do
    video = Streaming.video_of_owner!(id, user_id)
    {:ok, _video} = Streaming.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end

  def action(conn, _) do
    apply(
      __MODULE__,
      action_name(conn),
      [conn, conn.params, conn.assigns.current_user]
    )
  end

  defp load_categories(conn, _) do
    assign(conn, :categories, Streaming.categories())
  end
end
