defmodule LivewaveWeb.ChatroomLive.ChatroomRoom do
  use LivewaveWeb, :live_view
  import LivewaveWeb.Endpoint

  alias Livewave.Repo
  alias LivewaveWeb.Presence
  alias Livewave.Accounts.{User}
  alias Livewave.Rooms.Chatroom
  alias Livewave.Posts.{Message}

  def mount(%{"id" => room_id}, %{"user_id" => user_id}, socket) do
    topic = "chatroom: " <> room_id
    current_user = Repo.get(User, user_id)

    if connected?(socket) do
      subscribe(topic)

      Presence.track(self(), topic, current_user.username, %{
        id: current_user.id,
        username: current_user.username,
        email: current_user.email
      })
    end

    if String.contains?(Repo.get(Chatroom, room_id).name, [current_user.username]) do
      {:ok,
       assign(socket,
         current_user: current_user,
         messages: chatroom_messages(room_id),
         room_id: room_id,
         room_name: Repo.get(Chatroom, room_id).name,
         topic: topic,
         online_users: []
       )}
    else
      {:ok, socket |> redirect(to: ~p"/chatrooms")}
    end
  end

  def chatroom_messages(room_id) do
    Repo.all(Message)
    |> Enum.filter(fn msg -> msg.chatroom_id == String.to_integer(room_id) end)
  end

  # creates new chatroom
  def handle_event("save", %{"message" => message}, socket) do
    room_id = socket.assigns.room_id
    current_user = socket.assigns.current_user.id

    new_msg = Message.changeset(%Message{}, %{body: message, user_id: current_user, chatroom_id: String.to_integer(room_id)})

    IO.inspect(new_msg)

    case Repo.insert(new_msg) do
      {:ok, message} ->
        broadcast(socket.assigns.topic, "new-message", message)

        {:noreply, socket}

      {:error, _reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Messages can't be blank ")}
    end
  end

  # phx-change
  def handle_event("track", _params, socket) do
    {:noreply, socket}
  end

  # needed for broadcast
  def handle_info(%{event: "new-message", payload: message}, socket) do
    # IO.inspect(payload: message.body)
    {:noreply, assign(socket, messages: Repo.all(Message))}
  end

  # needed for presence.track
  def handle_info(%{event: "presence_diff", payload: %{joins: joins, leaves: leaves}}, socket) do
    online_users =
      Presence.list(socket.assigns.topic)
      |> Map.keys()

    {:noreply, assign(socket, online_users: online_users)}
  end

  def render(assigns) do
    ~H"""
    <div class="chatroom-head">
      <strong><%= @room_name %></strong>
    </div>
    <div class="online-card flex flex-col justify-center ">
      <strong class="underline">Online Users:</strong>
    <%= for online_user <- @online_users do %>
    <div>
      <span class="italic">@<%= online_user %></span>
    </div>
    <%end%>
    </div>
    <div class="chatroom">
      <div class="messages-area">
        <%= for message <- @messages do %>
          <%= if message.user_id == @current_user.id do %>
            <div class="card single-msg-current-user">
              <p><small>from: @<%= @current_user.username %></small></p>
              <strong class=""><%= message.body %></strong>
            </div>
          <% else %>
            <div class="card single-msg-other-user">
              <p><small>from: @<%= Repo.get(User, message.user_id).username %></small></p>
              <strong><%= message.body %></strong>
            </div>
          <% end %>
        <% end %>
      </div>
      <div class="chat-form">
        <form phx-submit="save">
          <textarea
            type="text"
            phx-change="track"
            name="message"
            class="textarea italic"
            placeholder="Message...."
          />
          <button class="button">Send</button>
        </form>
      </div>
    </div>
    """
  end
end
