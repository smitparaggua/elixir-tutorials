defmodule Rumbl.Accounts.UserRepoTest do
  use Rumbl.DataCase
  alias Rumbl.Accounts.User

  @valid_attrs %{name: "A User", username: "eva"}

  test "converts unique constraint to username error" do
    attrs = Map.put(@valid_attrs, :username, "eric")
    changeset = User.changeset(%User{}, attrs)
    {:ok, _} = Repo.insert(changeset)
    {:error, changeset} = Repo.insert(changeset)
    assert {:username, ["has already been taken"]} in errors_on(changeset)
  end
end
