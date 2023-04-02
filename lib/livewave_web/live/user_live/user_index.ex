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

  def handle_event("save", %{"value" => user_id}, socket) do
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
      user_already_has_chat?(chatroom, user) &&
        user_already_has_chat?(chatroom, current_user)
    end)
  end

  def user_already_has_chat?(chatroom, user) do
    String.contains?(chatroom.name, ["#{user.username}"])
  end

  def render(assigns) do
    ~H"""
    <div>
    </div>
    <div class="mx-auto max-w-lg">
      <ul class="space-y-4">
        <%= for user <- @users do  %>
        <%= unless user == @current_user do %>
          <li class="flex card mx-auto max-w-md rounded-tr-3xl rounded-lg shadow-lg shadow-blue-500/40">
          <div class="h-10 w-10 m-2">
            <img class="h-full w-full rounded-full object-cover object-center" src={user.image} alt="" />
          </div>
            <div class="flex-1">
                <h4 class="text-xl font-medium leading-loose">
                  <strong>@<%= user.username %></strong>
                </h4>
                <h4 class="text-l font-small leading-loose">
                  email: <%= user.email %>
                </h4>
            </div>
            <button phx-click="save" value={user.id} class="text-3xl mr-5">💬</button>
          </li>
          <%end %>
        <% end %>
      </ul>
    </div>
    """
  end
end
