defmodule RumblWeb.RequireUser do
  import Plug.Conn, only: [halt: 1]
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  alias RumblWeb.Router.Helpers, as: Routes

  def init(_opts) do
  end

  def call(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be loggin to access that age")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
