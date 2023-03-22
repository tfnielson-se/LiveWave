defmodule Livewave.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :token, :string
    field :provider, :string

    has_many :messages, Livewave.Posts.Message

    timestamps()
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:username, :email, :token, :provider,])
    |> validate_required([:username, :email, :token, :provider,])
    |> unique_constraint([:username, :email, :token])
  end
end
