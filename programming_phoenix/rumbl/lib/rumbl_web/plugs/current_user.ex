defmodule Rumbl.CurrentUser do
  import Plug.Conn

  def init(opts) do
    Keyword.fetch!(opts, :user_finder)
  end

  def call(conn, user_finder) do
    user_id = get_session(conn, :user_id)
    user = user_id && user_finder.(user_id)
    assign(conn, :current_user, user)
  end
end
