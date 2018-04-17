defmodule RumblWeb.Controllers.HelpersTest do
  use RumblWeb.ConnCase, async: true

  import Destructure

  alias RumblWeb.Controller.Helpers
  alias Rumbl.Accounts.User

  setup d%{conn} do
    conn =
      conn
      |> bypass_through(RumblWeb.Router, :browser)
      |> get("/")

    {:ok, d%{conn}}
  end

  test "login puts the user in session", d%{conn} do
    login_conn =
      conn
      |> Helpers.login(%User{id: 123})
      |> send_resp(:ok, "")

    next_conn = get(login_conn, "/")
    assert get_session(next_conn, :user_id) == 123
  end

  test "logout drops the user in session", d%{conn} do
    logout_conn =
      conn
      |> put_session(:user_id, 123)
      |> Helpers.logout()
      |> send_resp(:ok, "")

    next_conn = get(logout_conn, "/")
    refute get_session(next_conn, :user_id)
  end
end
