defmodule LivewaveWeb.ForumLive.ForumIndex do
  use LivewaveWeb, :live_view

  alias Livewave.Repo

  alias Livewave.Accounts
  # alias Livewave.Accounts.User

  alias Livewave.Posts
  alias Livewave.Posts.Comments

  alias Livewave.Rooms
  alias Livewave.Rooms.Forum

  def mount(_params, %{"user_id" => user_id}, socket) do
    {:ok,
     assign(socket,
       current_user: Accounts.get_user!(user_id),
       forums: Rooms.list_forums()
     )}
  end

  def handle_event("new-forum", %{"forum_name" => forum_name}, socket) do

    IO.inspect(Rooms.create_forum(%{name: forum_name}))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Forums</h1>
      <form phx-submit="new-forum">
        <input type="text" name="forum_name" placeholder="type your forum question here..." />
        <button>Create New Forum Post</button>
      </form>
      <%= for forum <- @forums do %>
      <%= forum.name %>
      <% end %>
    </div>
    """
  end
end
