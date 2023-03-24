defmodule LivewaveWeb.MessageLive.NewMessage do
  use LivewaveWeb, :live_view
  # alias Livewave.Posts
  # alias Livewave.Accounts.User

  def render(assigns) do
    ~H"""
    <div>
      <form phx-submit="new-msg">
        <div>
          <input type="text" label="input" />
        </div>
      </form>
    </div>
    """
  end

  def mount(_param, _session, socket) do
    {:ok, socket}
  end

  def handle_event() do
  end
end
