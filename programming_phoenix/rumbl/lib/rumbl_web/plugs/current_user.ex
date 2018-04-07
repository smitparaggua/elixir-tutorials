defmodule RumblWeb.CurrentUser do
  import Plug.Conn

  alias RumblWeb.Controller.Helpers, as: ControllerHelpers

  def init(opts) do
    Keyword.fetch!(opts, :user_finder)
  end

  def call(conn, user_finder) do
    user_id = get_session(conn, :user_id)
    cond do
      user = conn.assigns[:current_user] ->
        ControllerHelpers.put_current_user(conn, user)

      user = user_id && user_finder.(user_id) ->
        ControllerHelpers.put_current_user(conn, user)

      true -> assign(conn, :current_user, nil)
    end
  end
end
