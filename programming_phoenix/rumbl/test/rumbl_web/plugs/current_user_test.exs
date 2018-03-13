defmodule RumblWeb.CurrentUserTest do
  use RumblWeb.ConnCase, async: true

  import Destructure

  alias RumblWeb.CurrentUser
  alias Rumbl.Accounts

  setup d%{conn} do
    conn =
      conn
      |> bypass_through(RumblWeb.Router, :browser)
      |> get("/")

    {:ok, d%{conn}}
  end

  describe "no current_user exists and no user is found" do
    test "assigns empty current_user", d%{conn} do
      user_finder = fn (_) -> nil end
      conn = CurrentUser.call(conn, user_finder)
      assert conn.assigns[:current_user] == nil
    end
  end

  # TODO I stopped here
  describe "user exists that matches user_id" do
    test "assigns the matched user to connection", d%{conn} do
      user = %Accounts.User{id: 27}
      user_finder = &(&1 == 27 && user)
      conn =
        conn
        |> put_session(:user_id, 27)
        |> CurrentUser.call(user_finder)

      assert conn.assigns[:current_user] == user
    end
  end

  describe "no user exists with the user_id" do
    test "assigns the matched user to connection", d%{conn} do
      user = %Accounts.User{id: 27}
      user_finder = &(&1 == 27 && user)
      conn =
        conn
        |> put_session(:user_id, 27)
        |> CurrentUser.call(user_finder)

      assert conn.assigns[:current_user] == user
    end
  end
end
