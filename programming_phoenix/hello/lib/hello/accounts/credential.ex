defmodule Hello.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hello.Accounts.{Credential, User}


  schema "credentials" do
    field :email, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%Credential{} = credential, attrs) do
    credential
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> unique_constraint(:email)
  end
end
