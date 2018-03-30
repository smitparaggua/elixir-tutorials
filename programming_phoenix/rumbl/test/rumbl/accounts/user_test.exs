defmodule Rumbl.Accounts.UserTest do
  use Rumbl.DataCase, async: true
  alias Rumbl.Accounts.User

  @valid_attrs %{name: "A User", username: "eva", password: "secret"}

  describe "changeset" do
    test "with valid attributes" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "does not accept long usernames" do
      long_username = String.duplicate("a", 30)
      attrs = Map.put(@valid_attrs, :username, long_username)
      changeset = User.changeset(%User{}, attrs)
      refute changeset.valid?
      assert {:username, ["should be at most 20 character(s)"]}
        in errors_on(changeset)
    end
  end

  describe "registration_changeset" do
    test "requires at least 6 chars for password" do
      attrs = Map.put(@valid_attrs, :password, "12345")
      changeset = User.registration_changeset(%User{}, attrs)
      refute changeset.valid?
      assert {:password, ["should be at least 6 character(s)"]}
        in errors_on(changeset)
    end

    test "successful registration hashes the password" do
      pass = "some-secure-password"
      attrs = Map.put(@valid_attrs, :password, pass)
      changeset = User.registration_changeset(%User{}, attrs)
      assert Comeonin.Pbkdf2.checkpw(pass, changeset.changes.password_hash)
    end
  end
end
