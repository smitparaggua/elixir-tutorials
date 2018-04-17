defmodule RumblWeb.SessionController do
  use RumblWeb, :controller
  alias Rumbl.Auth
  alias RumblWeb.Controller.Helpers

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => user, "password" => pass}}) do
    case Auth.auth_by_username_and_password(user, pass) do
      {:ok, user} ->
        conn
        |> Helpers.login(user)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Helpers.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
