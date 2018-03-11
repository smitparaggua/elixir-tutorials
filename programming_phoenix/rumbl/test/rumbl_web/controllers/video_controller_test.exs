defmodule RumblWeb.VideoControllerTest do
  import Destructure
  use RumblWeb.ConnCase

  alias Rumbl.TestHelpers.Accounts
  alias Rumbl.TestHelpers.Streaming

  setup d(%{conn}) = config do
    if username = config[:login_as] do
      {:ok, user} = Accounts.create_user(d%{username})
      conn = assign(conn, :current_user, user)
      {:ok, d%{conn, user}}
    else
      :ok
    end
  end

  test "requires user authentication on all actions", d%{conn} do
    connections = [
      get(conn, video_path(conn, :new)),
      get(conn, video_path(conn, :index)),
      get(conn, video_path(conn, :show, "123")),
      get(conn, video_path(conn, :edit, "123")),
      put(conn, video_path(conn, :update, "123", %{})),
      post(conn, video_path(conn, :create, %{})),
      delete(conn, video_path(conn, :delete, "123"))
    ]
    for conn <- connections do
      assert html_response(conn, 302)
      assert conn.halted
    end
  end

  @tag login_as: "max"
  test "list all user's videos on index", d%{conn, user} do
    {:ok, user_video} =
      Streaming.create_video(%{owner_id: user.id, title: "funny cats"})

    {:ok, other_user} = Accounts.create_user()
    {:ok, other_video} =
      Streaming.create_video(%{title: "another video", owner_id: other_user.id})

    conn = get(conn, video_path(conn, :index))
    assert html_response(conn, 200) =~ ~r/Listing Videos/
    assert String.contains?(conn.resp_body, user_video.title)
    refute String.contains?(conn.resp_body, other_video.title)
  end

  @tag login_as: "max"
  test "creates user video and redirects", d%{conn, user}  do
    video_attrs = %{url: "http://youtu.be", title: "vid", description: "a vid"}
    conn = post(conn, video_path(conn, :create), video: video_attrs)
    created = Streaming.get_video_by!(video_attrs)
    assert redirected_to(conn) == video_path(conn, :show, created.id)
    assert created.owner_id == user.id
  end

  @tag login_as: "max"
  test "does not create video and renders errors when invalid", d%{conn} do
    before_count = Streaming.number_of_videos
    conn = post(conn, video_path(conn, :create), video: %{invalid: "invalid"})
    assert html_response(conn, 200) =~ "check the errors"
    assert Streaming.number_of_videos == before_count
  end
end
