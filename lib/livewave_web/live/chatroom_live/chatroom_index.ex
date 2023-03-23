defmodule LivewaveWeb.ChatroomLive.ChatroomIndex do
  use LivewaveWeb, :live_view

  alias Livewave.Rooms
  alias Livewave.Rooms.Chatroom

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       chatrooms: Rooms.list_chatrooms()
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-lg">
      <ul class="ml-4 list-disc">
        <%= for chatroom <- @chatrooms do %>
          <li>
            <%= chatroom.name %>
          </li>
        <% end %>
        <li>Deliver instant answers</li>
        <li>Manage your team with reports</li>
        <li>Connect with customers</li>
        <li>Connect the tools you already use</li>
      </ul>
    </div>
    """
  end
end
