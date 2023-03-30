defmodule LivewaveWeb.ForumLive.ForumIndex do
  use LivewaveWeb, :live_view
  import LivewaveWeb.Endpoint
  import Ecto.Query
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
       forums: Enum.reverse(Repo.all(Forum)),
       search: [],
       show_form: false,
       show_search: true,
       topic: topic
     )}
  end

  def handle_event("toggle-new-post", _params, socket) do
    {:noreply, assign(socket, show_form: !socket.assigns.show_form)}
  end

  def handle_event("toggle-search", _params, socket) do
    {:noreply, assign(socket, show_search: !socket.assigns.show_search)}
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
         |> put_flash(:error, "Comments can't be blank ")}
    end
  end

  def handle_info(%{event: "new-forum-added", payload: forum}, socket) do
    {:noreply, assign(socket, forums: Enum.reverse(Repo.all(Forum)))}
  end

  def handle_event("delete-forum", %{"value" => forum_id}, socket) do
    delete_messages_from_chatroom(forum_id)

    Repo.get(Forum, forum_id)
    |> Repo.delete()

    {:noreply, assign(socket, forums: Enum.reverse(Repo.all(Forum)))}
  end

  def delete_messages_from_chatroom(forum_id) do
    query = from(comment in Comment, where: comment.forum_id == ^forum_id)
    Repo.delete_all(query)
  end

  #  TODO
  def handle_event("search", %{"search" => search}, socket) do
    forum_search =
      Enum.filter(Repo.all(Forum), fn forum ->
        String.contains?(String.downcase(forum.name), String.downcase(search))
      end)

    {:noreply, assign(socket, forums: forum_search)}
  end

  def render(assigns) do
    ~H"""
    <div class="flex justify-right mx-20 mb-2">
      <strong>Forums:</strong>
    </div>
    <div class="flex flex-row">
    <div class=" forum-left flex flex-col mx-10">
      <button phx-click="toggle-search" value={@show_search} class="btn rounded-t-lg">
        Search
      </button>
      <%= if @show_search do %>
    <form phx-submit="submit-search" class="forum-form">
      <input phx-change="search"  name="search" type="text" class="textarea w-full bg-transparent italic" placeholder="Search..." />
    </form>
    <%end%>
      <button phx-click="toggle-new-post" value={@show_form} class="btn rounded-t-lg">
      <%= if @show_form do %>
        Hide Form
      <% else %>
        Add New Forum Post
      <%end%>
      </button>
    <%= if @show_form do %>
    <form phx-submit="new-forum" class="forum-form">
      <label class="text-gray-200">Forum Post:</label>
      <textarea type="text" name="forum_name" class="textarea w-full bg-transparent italic" placeholder="Type here..." />
      <button class="btn w-full rounded-b-lg"> Submit </button>
    </form>
    <%end%>
    </div>
    <div class="forum-right" >
      <ul class="forum space-y-4">
        <%= for forum <- @forums do  %>
          <li class="flex forum-post card mx-auto max-w-md rounded-tr-3xl rounded-lg shadow-lg shadow-blue-500/40">
            <div class="m-3">
                <h4 class="text-xl font-medium leading-loose">
                <strong><%= forum.name %></strong>
                </h4>
                <button phx-click="delete-forum" class="text-l font-small leading-loose" value={forum.id}>
                🗑️
                </button>
                <.link navigate={~p"/forums/#{forum.id}"} class="text-l font-small leading-loose" value={forum.id}>
                🔎
                </.link>
            </div>
          </li>
        <% end %>
      </ul>
    </div>
    </div>
    """
  end
end
