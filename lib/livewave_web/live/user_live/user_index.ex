defmodule LivewaveWeb.UserLive.UserIndex do
  use LivewaveWeb, :live_view

  alias Livewave.Repo
  alias Livewave.Accounts
  alias Livewave.Accounts.User

  alias Livewave.Rooms

  require Logger

  def mount(_params, %{"user_id" => user_id}, socket) do
    current_user = Repo.get(User, user_id)
    {:ok, assign(socket, users: Accounts.list_users(), current_user: current_user)}
  end

  @implt true

  def handle_event("new-chat", %{"value" => user_id}, socket) do
    current_user = socket.assigns.current_user
    user = Repo.get(User, user_id)

    cond do
      check_existing_room?(user, current_user) == false ->
        name = "Chat between: #{user.username} & #{current_user.username}"

        {:ok, new_room} = Rooms.create_chatroom(%{name: name})
        {:noreply, redirect(socket, to: ~p"/chatrooms/#{new_room.id}")}

      check_existing_room?(user, current_user) ->
        {:noreply, redirect(socket, to: ~p"/chatrooms/")}
    end
  end

  def check_existing_room?(user, current_user) do
    Enum.any?(Rooms.list_chatrooms(), fn chatroom ->
      String.contains?(chatroom.name, ["#{user.username}"]) &&
        String.contains?(chatroom.name, ["#{current_user.username}"])
    end)
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-lg">
    <div class="divide-y divide-gray-200 rounded-xl border border-gray-200 shadow-sm text-center my-2 bg-gradient-to-r from-transparent to-blue-500">Online Users</div>
    <ul class="divide-y divide-gray-200 rounded-xl border border-gray-200 shadow-sm">
    <%= for user <- @users do %>
    <li class="p-4">
      <h4 class="text-lg font-medium leading-loose">
      <%= user.username %>
      </h4>
      <p class="text-gray-500">
      <%= user.email %>
      </p>
      <button phx-click="new-chat" value={"#{user.id}"} class="underline">Chat</button>
    </li>
    <%end%>
    </ul>
    </div>
    """
  end
end
