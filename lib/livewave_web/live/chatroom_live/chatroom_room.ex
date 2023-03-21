defmodule LivewaveWeb.ChatroomLive.ChatroomRoom do
  use LivewaveWeb, :live_view


  alias Livewave.Accounts
  alias Livewave.Accounts.User

  alias Livewave.Posts
  alias Livewave.Posts.Message

  def mount(_params, %{"user_id" => user_id} = session, socket) do
    IO.inspect("-------socket ------>")
    IO.inspect(socket)
    {:ok, assign(socket, current_user: Accounts.get_user!(user_id), messages: Posts.list_messages())}
  end

  def handle_event("submit", %{"message" => message} = params, socket) do
    IO.inspect(socket)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1> <%= @current_user.id %> </h1>
      <form phx-submit="submit">
        <textarea phx-change="" name="message" />
      <button class="button" > Send </button>
      </form>
    </div>
    """
  end
end
