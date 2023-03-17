defmodule Livewave.Posts.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :body, :string
    field :user_id, :id
    field :chatroom_id, :id

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body])
    |> validate_required([:body, :user_id, :chatroom_id])
    |> validate_length(:body, min: 2, max: 100)
  end
end
