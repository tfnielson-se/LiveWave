defmodule LivewaveWeb.UserLive.UserProfile do
  use LivewaveWeb, :live_view

  require Logger
  alias Livewave.Repo
  alias Livewave.Accounts.{User}

  def mount(_params, %{"user_id" => user_id}, socket) do
    current_user = Repo.get(User, user_id)
    IO.inspect(current_user)
    {:ok, assign(socket, :current_user, current_user)}
  end

  def handle_event("edit", _session, socket) do
    {:noreply, redirect(socket, to: ~p"/users/:id/edit")}
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-lg">
      <ul class="space-y-4">
          <li class="flex card mx-auto max-w-md rounded-tr-3xl rounded-lg shadow-lg shadow-blue-500/40">
          <div class="h-10 w-10 m-2">
            <img class="h-full w-full rounded-full object-cover object-center" src={@current_user.image} alt="" />
          </div>
            <div class="flex-1">
                <h4 class="text-xl font-medium leading-loose">
                  <strong>@<%= @current_user.username %></strong>
                </h4>
                <h4 class="text-l font-small leading-loose">
                  email: <%= @current_user.email %>
                </h4>
            </div>
          </li>
      </ul>
    </div>
    """
  end
end
