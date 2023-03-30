defmodule LivewaveWeb.ForumLive.ForumShow do
  use LivewaveWeb, :live_view
  import LivewaveWeb.Endpoint

  alias Livewave.Repo
  alias Livewave.Posts.{Comment}
  alias Livewave.Accounts.{User}
  alias Livewave.Rooms.{Forum}

  def mount(%{"id" => forum_id}, %{"user_id" => user_id}, socket) do
    topic = "forum" <> forum_id

    if connected?(socket) do
      subscribe(topic)
    end

    {:ok,
     assign(socket,
       current_user: Repo.get(User, user_id),
       comments: Repo.all(Comment),
       forum: Repo.get!(Forum, String.to_integer(forum_id)),
       topic: topic,
       hide_edit: false,
       edit_comment: nil
     )}
  end

  # NEW COMMENT
  def handle_event("new-comment", %{"body" => body}, socket) do
    current_user = socket.assigns.current_user
    forum = socket.assigns.forum

    new_comment =
      Comment.changeset(%Comment{}, %{body: body, user_id: current_user.id, forum_id: forum.id})

    case Repo.insert(new_comment) do
      {:ok, comment} ->
        broadcast(socket.assigns.topic, "new-comment", comment)
        {:noreply, socket}

      {:error, _reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Comments can't be blank")}
    end
  end

  # TRACK CHANGE // ON CHANGE
  def handle_event("track", _params, socket) do
    {:noreply, socket}
  end

  # DELETE COMMENT
  def handle_event("delete", %{"value" => comment_id} = params, socket) do
    Repo.get!(Comment, comment_id)
    |> Repo.delete()

    {:noreply, assign(socket, comments: Repo.all(Comment))}
  end

  def handle_event("open-edit", %{"value" => comment_id} = params, socket) do
    edit_comment = Repo.get(Comment, comment_id)
    {:noreply, assign(socket, hide_edit: !socket.assigns.hide_edit, edit_comment: edit_comment)}
  end

  def handle_event("edit", %{"body" => body} = params, socket) do
    edit_comment = socket.assigns.edit_comment
    |> Ecto.Changeset.change(body: body)
    |> Repo.update()

    broadcast(socket.assigns.topic, "updated-comment", edit_comment)

    {:noreply, assign(socket, hide_edit: !socket.assigns.hide_edit)}
  end

  def handle_info(%{event: "new-comment", payload: comment}, socket) do
    # {:noreply, socket}
    {:noreply, assign(socket, comments: socket.assigns.comments ++ [comment])}
  end

  def handle_info(%{event: "updated-comment", payload: comment}, socket) do
    {:noreply, assign(socket, comments: Repo.all(Comment))}
  end

  def render(assigns) do
    ~H"""
    <div class="forum-show shadow-lg mx-auto max-w-xl p-5 rounded-xl">
    <div class="flex gap-4">
    <div class="flex-1">
      <h4 class="text-lg font-medium underline">Forum Question:</h4>
      <p class="mt-3 italic text-xl text-gray-900"><%= @forum.name%></p>
      <%= for comment <- @comments  do %>
      <%= if comment.forum_id == @forum.id do%>
      <div class="mt-4 flex gap-4">
        <span class="text-3xl">🗣️</span>
        <div class="flex-1 mb-2">
          <h4 class="text-lg font-medium">@<%= Repo.get(User, comment.user_id).username%></h4>
          <p class="mt-1 text-gray-900">
          <%= comment.body %>
          </p>
          <%= if comment.user_id == @current_user.id do %>
          <button phx-click="delete" value={comment.id}>🗑️</button>
          <button phx-click="open-edit" value={comment.id}>📝</button>
          <%end%>
        </div>
      </div>
      <hr>
      <%end%>
      <%end%>
      <div class="mt-4 flex gap-4">
        <div class="flex-1">
        <form phx-submit="new-comment">
          <h4 class="text-lg font-medium">New Comment:</h4>
          <textarea phx-change="track" name="body" class="m-1 textarea rounded-lg"/>
          <button class="card rounded-lg bg-zinc-900 px-2 py-1 text-[0.8125rem] font-semibold leading-6 text-zinc-100"> Submit </button>
        </form>
        </div>
      </div>
    </div>
    </div>
    </div>
      <%= if @hide_edit do %>
    <div class="btn shadow-lg mx-auto max-w-xl p-1 rounded-t-xl text-center">
      <p>
      Edit Form
      </p>
    </div>
    <div class="edit-comment bg-gray-800 shadow-lg mx-auto max-w-xl rounded-b-xl text-center">
      <form phx-submit="edit">
        <input class="textarea my-4 px-2 rounded-sm" value={@edit_comment.body} name="body"/>
        <button class="edit-btn"> Edit </button>
      </form>
    </div>
      <%end%>
    """
  end
end
