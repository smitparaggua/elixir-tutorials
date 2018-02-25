defmodule Rumbl.Auth do
  import Comeonin.Pbkdf2, only: [checkpw: 2, dummy_checkpw: 0]

  alias Rumbl.Accounts

  def auth_by_username_and_password(username, given_pass) do
    user = Accounts.get_user_by_username(username)

    cond do
      user && checkpw(given_pass, user.password_hash) -> {:ok, user}
      user -> {:error, :unauthorized}

      true ->
        dummy_checkpw()
        {:error, :not_found}
    end
  end
end
