defmodule LivewaveWeb.ChatroomLive.ChatroomRoom do
  use LivewaveWeb, :live_view
  import LivewaveWeb.Endpoint

  alias Livewave.Repo
  alias Livewave.Accounts
  alias Livewave.Accounts.User

  alias Livewave.Posts
  alias Livewave.Posts.Message

  @impl true
  def mount(%{"id" => room_id}, %{"user_id" => user_id} = session, socket) do
    topic = "chatroom: " <> room_id

    if connected?(socket) do
    subscribe(topic)
    end

    {:ok,
     assign(socket,
       current_user: Accounts.get_user!(user_id),
       messages: chatroom_messages(room_id),
       room_id: room_id,
       room_name: Repo.get(Livewave.Rooms.Chatroom, room_id).name,
       topic: topic
     )}
  end

  def chatroom_messages(room_id) do
    Enum.filter(Posts.list_messages(), fn msg ->
      msg.chatroom_id == String.to_integer(room_id)
    end)
  end


  @impl true
  def handle_event("submit", %{"message" => message}, socket) do
    room_id = socket.assigns.room_id
    current_user = socket.assigns.current_user.id

    case Posts.create_message(%{body: message, user_id: current_user, chatroom_id: room_id}) do
      {:ok, message} ->
        broadcast(socket.assigns.topic, "new-message", message)
        {:noreply,
          socket
          |> put_flash(:info, "Message Sent")}

        {:error, _reason} ->
        {:noreply,
          socket
          |> put_flash(:error, "Messages can't be blank ")}
    end
  end

  # needed for broadcast
  def handle_info(%{event: "new-message", payload: message}, socket) do
    # IO.inspect(payload: message.body)
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [message])}
  end

  def handle_event("track", _params, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="chatroom">
      <strong class="mb-5 underline"> <%= @room_name %> </strong>
      <div class="messages-area">
    <%= for message <- @messages do %>
      <%= if message.user_id == @current_user.id do%>
        <div class="single-msg-current-user" >
          <p><small> from: <%= @current_user.username %> </small></p>
          <strong> <%= message.body %> </strong>
        </div>
      <% else %>
        <div class="single-msg-other-user" >
          <p><small> from: <%= Repo.get(User, message.user_id).username %> </small></p>
          <strong> <%= message.body %> </strong>
        </div>
      <% end %>
    <% end %>
      </div>
      <div class="chat-form">
        <form phx-submit="submit">
            <textarea type="text" phx-change="track" name="message" class="textarea italic" placeholder="Message...."/>
            <button class="button"> Send </button>
        </form>
      </div>
    </div>
    """
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
