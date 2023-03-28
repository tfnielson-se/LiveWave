defmodule LivewaveWeb.ForumLive.ForumIndex do
  use LivewaveWeb, :live_view

  # alias Livewave.Repo

  alias Livewave.Accounts
  # alias Livewave.Accounts.User

  alias Livewave.Posts
  # alias Livewave.Posts.Comments

  alias Livewave.Rooms
  # alias Livewave.Rooms.Forum

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
    <div class="mx-auto max-w-lg">
    <strong> Forums </strong>
      <ul class="space-y-4">
        <%= for forum <- @forums do  %>

          <li class="flex card mx-auto max-w-md rounded-tr-3xl rounded-lg shadow-lg shadow-blue-500/40">
            <div class="flex h-10 w-10 items-center justify-center rounded-full bg-primary-100">

            </div>
            <div class="flex-1">
                <h4 class="text-xl font-medium leading-loose">
                <strong><%= forum.name %></strong>
                </h4>
                <h4 class="text-l font-small leading-loose">

                </h4>
            </div>
          </li>

        <% end %>
      </ul>
    </div>
    """
  end
end
