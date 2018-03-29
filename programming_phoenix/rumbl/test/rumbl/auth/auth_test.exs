defmodule Rumbl.AuthTest do
  use Rumbl.DataCase

  import Destructure

  alias Rumbl.Auth
  alias Rumbl.AccountsTestHelpers

  setup do
    subject = &Auth.auth_by_username_and_password/2
    {:ok, d%{subject}}
  end

  test "auth with valid username and pass", d%{subject} do
    {:ok, user} =
      AccountsTestHelpers.create_user(%{username: "me", password: "secret"})

    {:ok, authenticated} = subject.("me", "secret")
    assert authenticated.id == user.id
  end

  test "auth with a not found user", d%{subject} do
    assert subject.("not", "found") == {:error, :not_found}
  end

  test "auth password mismatch", d%{subject} do
    AccountsTestHelpers.create_user(%{username: "me", password: "secret"})
    assert subject.("me", "wrongpassword") == {:error, :unauthorized}
  end
end
