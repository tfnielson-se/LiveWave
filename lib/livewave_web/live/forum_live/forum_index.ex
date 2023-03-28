defmodule LivewaveWeb.ForumLive.ForumIndex do
  use LivewaveWeb, :live_view
  import LivewaveWeb.Endpoint

  alias Livewave.Repo

  alias Livewave.Accounts.{User}
  alias Livewave.Posts.{Comment}
  alias Livewave.Rooms.{Forum}

  def mount(_params, %{"user_id" => user_id}, socket) do
    topic = "forum main"

    if connected?(socket) do
      subscribe(topic)
    end
    {:ok,
     assign(socket,
       current_user: Repo.get!(User, user_id),
       forums: Repo.all(Forum),
       search: [],
       show_form: false,
       topic: topic
     )}
  end

  def handle_event("toggle-new-post", params, socket) do
    {:noreply, update(socket, :show_form, fn x -> !x end)}
  end

  def handle_event("new-forum", %{"forum_name" => forum_name}, socket) do
    # FIX ME
    case Repo.insert(%Forum{name: forum_name}) do
      {:ok, new_forum} ->
        broadcast(socket.assigns.topic, "new-forum-added", new_forum)

        {:noreply, socket}

      {:error, _reason} ->
          {:noreply,
           socket
           |> put_flash(:error, "Messages can't be blank ")}
    end
  end

  def handle_info(%{event: "new-forum-added", payload: foum}, socket) do
    {:noreply, assign(socket, forums: Repo.all(Forum))}
  end

  def handle_event("delete-forum", %{"value" => forum_id}, socket) do
    # IO.inspect(forum_id)
    Repo.get(Forum, forum_id)
    |> Repo.delete()

    {:noreply, assign(socket, forums: Repo.all(Forum))}
  end

  #  TODO
  def handle_event("search", %{"search" => search}, socket) do
    IO.inspect(search)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex justify-between mx-10">
      <strong> Forums: </strong>
      <form class="search-bar">
        <input phx-change="search" placeholder="search" name="search"/>
      </form>
    </div>
    <div class="flex flex-row">
    <div class="flex flex-col mx-10 max-w-lg">
      <button phx-click="toggle-new-post" value={@show_form}> New Forum Post </button>
    <%= if @show_form do %>
    <form phx-submit="new-forum">
      <label>Enter your question</label>
      <input type="text" name="forum_name" class="block w-full border-0 border-b-2 border-gray-200 focus:border-primary-500 focus:ring-0 disabled:cursor-not-allowed disabled:text-gray-500 bg-transparent" placeholder="Underline" />
      <button> Submit </button>
    </form>
    <%end%>
    </div>
    <div class=" flex flex-col mx-auto mt-3 max-w-lg" >
      <ul class="space-y-4">
        <%= for forum <- @forums do  %>
          <li class="flex card mx-auto max-w-md rounded-tr-3xl rounded-lg shadow-lg shadow-blue-500/40">
            <div class="flex h-10 w-10 items-center justify-center rounded-full bg-primary-100">
            </div>
            <div class="flex-1">
                <h4 class="text-xl font-medium leading-loose">
                <strong><%= forum.name %></strong>
                </h4>
                <button phx-click="delete-forum" class="text-l font-small leading-loose" value={forum.id}>
                🗑️
                </button>
            </div>
          </li>
        <% end %>
      </ul>
    </div>
    </div>
    """
  end
end
