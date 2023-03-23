defmodule Livewave.Rooms.Chatroom do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chatrooms" do
    field :name, :string

    has_many :messages, Livewave.Posts.Message, on_delete: :delete_all
    has_many :users, through: [:messages, :user]

    timestamps()
  end

  @doc false
  def changeset(chatroom, attrs) do
    chatroom
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
