defmodule LivewaveWeb.ChatroomLive.ChatroomIndex do
  use LivewaveWeb, :live_view
  import Ecto.Query

  alias Livewave.Repo
  alias Livewave.Rooms

  alias Livewave.Posts

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       chatrooms: Rooms.list_chatrooms()
     )}
  end

  def handle_event("delete", %{"value" => room_id}, socket) do
    query = from(msg in Livewave.Posts.Message, where: msg.chatroom_id == ^room_id)
    Repo.delete_all(query)

    Rooms.get_chatroom!(String.to_integer(room_id))
    |> Repo.delete()

    {:noreply,
     assign(socket,
       chatrooms: Rooms.list_chatrooms()
     )}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-lg">
      <ul class="space-y-4">
        <%= for chatroom <- @chatrooms do %>
          <li class="flex border-b border-zinc-100 gap-4">
            <div class="flex h-10 w-10 items-center justify-center rounded-full bg-primary-100">
              <h1 class="text-3xl">💬</h1>
            </div>
            <div class="flex-1">
              <.link navigate={~p"/chatrooms/#{chatroom.id}"}>
                <h4 class="text-xl font-medium leading-loose">
                  <%= chatroom.name %>
                </h4>
              </.link>
              <p class="text-gray-500 underline">Actions</p>
              <button phx-click="delete" value={chatroom.id} class="text-2xl">🗑️</button>
            </div>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end
end
