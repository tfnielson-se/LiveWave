defmodule LivewaveWeb.ForumLive.ForumIndex do
  use LivewaveWeb, :live_view

  alias Livewave.Repo

  alias Livewave.Accounts
  alias Livewave.Accounts.User

  alias Livewave.Posts
  alias Livewave.Posts.Comments

  alias Livewave.Rooms
  alias Livewave.Rooms.Forum

  def mount(_params, %{"user_id" => user_id}, socket) do

    {:ok, assign(socket,
      current_user: Accounts.get_user!(user_id),
      forums: Rooms.list_forums,
    )}
  end

  def handle_event("new-forum", _params, socket) do
    # Rooms.create_forum(Forum, )
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1> Forums </h1>
      <button phx-click="new-forum"> Create New Forum Post </button>
    </div>
    """
  end
end
