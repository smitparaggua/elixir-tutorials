defmodule Rumbl.Accounts do
  alias Rumbl.Repo
  alias Rumbl.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_user(user_params \\ %{}) do
    %User{}
    |> User.changeset(user_params)
    |> Repo.insert()
  end
end
