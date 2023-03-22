defmodule LivewaveWeb.UserLive.UserIndex do
  use LivewaveWeb, :live_view

  require Logger

  alias Livewave.Repo
  alias Livewave.Accounts
  alias Livewave.Accounts.User

  alias Livewave.Rooms
  alias Livewave.Posts

  def mount(_params, %{"user_id" => user_id}, socket) do
    current_user = Repo.get(User, user_id)
    {:ok, assign(socket, users: Accounts.list_users(), current_user: current_user)}
  end

  @implt true

  def handle_event("new-chat", %{"value" => user_id}, socket) do
    current_user = socket.assigns.current_user
    user = Repo.get(User, user_id)

    {:ok, new_room} = Rooms.create_chatroom(%{name: "Chat between: #{user.username} & #{current_user.username}"})
    {:noreply, redirect(socket, to: ~p"/chatrooms/#{new_room.id}")}
  end

  def render(assigns) do
    ~H"""
<div class="mx-auto max-w-lg">
  <ul class="divide-y divide-gray-200 rounded-xl border border-gray-200 shadow-sm">
    <%= for user <- @users do %>
    <li class="p-4">
      <h4 class="text-lg font-medium leading-loose">
      <%= user.username %>
      </h4>
      <p class="text-gray-500">
      <%= user.email %>
      </p>
    </li>
    <%end%>
  </ul>
</div>
    """
  end
end
