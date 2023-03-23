defmodule Livewave.Posts.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :body, :string
    # field :user_id, :id
    # field :chatroom_id, :id

    belongs_to :chatroom, Livewave.Rooms.Chatroom, foreign_key: :chatroom_id
    belongs_to :user, Livewave.Accounts.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :user_id, :chatroom_id])
    |> validate_required([:body, :user_id, :chatroom_id])
    |> validate_length(:body, min: 1, max: 100)
  end
end
