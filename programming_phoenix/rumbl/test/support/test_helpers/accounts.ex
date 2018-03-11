defmodule Rumbl.TestHelpers.Accounts do
  alias Rumbl.Accounts

  def create_user(user_params \\ %{}) do
    defaults = %{
      name: "Some User",
      username: "user#{Base.encode16(:crypto.strong_rand_bytes(8))}",
      password: "supersecret"
    }

    defaults
    |> Map.merge(user_params)
    |> Accounts.create_user
  end
end
