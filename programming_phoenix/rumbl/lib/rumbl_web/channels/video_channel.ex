defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel
  import Destructure

  def join("videos:" <> video_id, _params, socket) do
    {:ok, socket}
  end

  def handle_info(:ping, socket) do
    count = socket.assigns[:count] || 1
    push(socket, "ping", d%{count})
    {:noreply, assign(socket, :count, count + 1)}
  end

  def handle_in("new_annotation", params, socket) do
    message = %{
      user: %{username: "anon"},
      body: params["body"],
      at: params["at"]
    }

    broadcast!(socket, "new_annotation", message)
    {:reply, :ok, socket}
  end
end
