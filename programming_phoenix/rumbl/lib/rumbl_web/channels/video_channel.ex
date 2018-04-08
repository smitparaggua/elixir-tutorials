defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel
  import Destructure
  alias Rumbl.{Streaming, Accounts}
  alias RumblWeb.{UserView, AnnotationView}

  def join("videos:" <> video_id, params, socket) do
    last_seen_id = params["last_seen_id"] || 0
    video_id = String.to_integer(video_id)
    annotations =
      video_id
      |> Streaming.first_annotations_of_video(200, last_seen_id)
      |> Streaming.annotations_with_user(&Accounts.list_users/1)

    annotation_renders =
      Phoenix.View.render_many(annotations, AnnotationView, "annotation.json")

    resp = %{annotations: annotation_renders}
    {:ok, resp, assign(socket, :video_id, video_id)}
  end

  def handle_info(:ping, socket) do
    count = socket.assigns[:count] || 1
    push(socket, "ping", d%{count})
    {:noreply, assign(socket, :count, count + 1)}
  end

  def handle_in(event, params, socket) do
    user = Accounts.get_user(socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_annotation", params, user, socket) do
    case Streaming.add_annotation(user.id, socket.assigns.video_id, params) do
      {:ok, annotation} ->
        message = %{
          user: UserView.render("user.json", d%{user}),
          body: annotation.body,
          at: annotation.at,
          id: annotation.id
        }

        broadcast!(socket, "new_annotation", message)
        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
