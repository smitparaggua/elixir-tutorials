defmodule RumblWeb.VideoViewTest do
  use RumblWeb.ConnCase, async: true

  import Phoenix.View
  import Destructure

  alias Rumbl.StreamingTestHelpers
  alias RumblWeb.VideoView

  test "renders index.html", d%{conn} do
    videos = [
      StreamingTestHelpers.build_video(%{id: 1, title: "dogs"}),
      StreamingTestHelpers.build_video(%{id: 2, title: "cats"})
    ]

    content =
      render_to_string(VideoView, "index.html", conn: conn, videos: videos)

    assert String.contains?(content, "Listing Videos")
    for video <- videos do
      assert String.contains?(content, video.title)
    end
  end

  test "renders new.html", d%{conn} do
    changeset = StreamingTestHelpers.change_video()
    categories = [{"cats", 123}]
    content = render_to_string(VideoView, "new.html",
      conn: conn,
      changeset: changeset,
      categories: categories
    )

    assert String.contains?(content, "New Video")
  end
end
