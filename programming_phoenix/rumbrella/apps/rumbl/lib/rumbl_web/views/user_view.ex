defmodule RumblWeb.UserView do
  use RumblWeb, :view
  import Destructure
  alias Rumbl.Accounts.User

  def first_name(%User{name: name}) do
    name |> String.split(" ") |> Enum.at(0)
  end

  def render("user.json", d%{user}) do
    Map.take(user, [:id, :username])
  end
end
