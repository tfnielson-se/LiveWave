defmodule LivewaveWeb.ChatroomLive.ChatroomIndex do
  use LivewaveWeb, :live_view
  import Ecto.Query

  alias Livewave.Repo
  alias Livewave.Rooms.{Chatroom}
  alias Livewave.Accounts.{User}

  alias Livewave.Posts.{Message}

  def mount(_params, %{"user_id" => user_id}, socket) do

    {:ok,
     assign(socket,
       chatrooms: Repo.all(Chatroom),
       current_user: Repo.get(User, user_id)
     )}
  end

  def handle_event("delete", %{"value" => room_id}, socket) do
    delete_messages_from_chatroom(room_id)

    Repo.get!(Chatroom, String.to_integer(room_id))
    |> Repo.delete()

    {:noreply,
     assign(socket,
       chatrooms: Repo.all(Chatroom)
     )}
  end

  def delete_messages_from_chatroom(room_id) do
    query = from(msg in Message, where: msg.chatroom_id == ^room_id)
    Repo.delete_all(query)
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-lg">
      <ul class="space-y-4">
        <%= for chatroom <- @chatrooms do %>
        <%= if String.contains?(chatroom.name, ["#{@current_user.username}"]) do %>
          <li class="flex card mx-auto max-w-md rounded-tr-3xl rounded-lg shadow-lg shadow-blue-500/40">
            <div class="flex h-10 w-10 items-center justify-center rounded-full bg-primary-100">
              <h1 class="text-3xl">💬</h1>
            </div>
            <div class="flex-1">
              <.link navigate={~p"/chatrooms/#{chatroom.id}"}>
                <button class="text-xl font-medium leading-loose">
                  <%= chatroom.name %>
                </button>
              </.link>
              <div class="flex justify-end mr-3 mb-2">
              <button phx-click="delete" value={chatroom.id} class="text-2xl">🗑️</button>
              </div>
            </div>
          </li>
        <%end%>
        <% end %>
      </ul>
    </div>
    """
  end
end
