defmodule LivewaveWeb.ChatroomLive.Index do
  use LivewaveWeb, :live_view

  alias Livewave.Rooms
  alias Livewave.Rooms.Chatroom

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :chatrooms, Rooms.list_chatrooms())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Chatroom")
    |> assign(:chatroom, Rooms.get_chatroom!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Chatroom")
    |> assign(:chatroom, %Chatroom{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Chatrooms")
    |> assign(:chatroom, nil)
  end

  @impl true
  def handle_info({LivewaveWeb.ChatroomLive.FormComponent, {:saved, chatroom}}, socket) do
    {:noreply, stream_insert(socket, :chatrooms, chatroom)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    chatroom = Rooms.get_chatroom!(id)
    {:ok, _} = Rooms.delete_chatroom(chatroom)

    {:noreply, stream_delete(socket, :chatrooms, chatroom)}
  end
end
