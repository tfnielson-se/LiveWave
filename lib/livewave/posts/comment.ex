defmodule Livewave.Posts.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    # field :user_id, :id
    # field :forum_id, :id

    belongs_to :forum, Livewave.Rooms.Forum, foreign_key: :forum_id
    belongs_to :user, Livewave.Accounts.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :user_id, :forum_id])
    |> validate_required([:body, :user_id, :forum_id])
    |> validate_length(:body, min: 1)
  end
end
