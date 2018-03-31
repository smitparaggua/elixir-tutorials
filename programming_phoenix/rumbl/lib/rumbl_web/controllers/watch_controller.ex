defmodule RumblWeb.WatchController do
  use RumblWeb, :controller
  alias Rumbl.Streaming

  def show(conn, %{"id" => id}) do
    video = Streaming.get_video!(id)
    render(conn, "show.html", video: video)
  end
end
