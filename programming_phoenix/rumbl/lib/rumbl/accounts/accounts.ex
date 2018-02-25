defmodule Rumbl.Accounts do
  alias Rumbl.Repo
  alias Rumbl.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end

  def user_change(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_user(user_params \\ %{}) do
    %User{}
    |> User.registration_changeset(user_params)
    |> Repo.insert()
  end
end
