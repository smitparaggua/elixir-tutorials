defmodule RumblWeb.RequireUserTest do
  use RumblWeb.ConnCase, async: true

  import Destructure

  alias RumblWeb.RequireUser

  setup d%{conn} do
    conn =
      conn
      |> bypass_through(RumblWeb.Router, :browser)
      |> get("/")

    {:ok, d%{conn}}
  end

  describe "no current user exists" do
    test "redirects us to index", d%{conn} do
      conn = RequireUser.call(conn, %{})
      assert redirected_to(conn) == "/"
    end

    test "halts the connection", d%{conn} do
      conn = RequireUser.call(conn, %{})
      assert conn.halted
    end

    test "adds login error to flash", d%{conn} do
      conn = RequireUser.call(conn, %{})
      assert get_flash(conn, :error)
    end
  end
end
