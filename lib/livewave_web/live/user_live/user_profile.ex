defmodule LivewaveWeb.UserLive.UserProfile do
  use LivewaveWeb, :live_view

  require Logger

  alias Livewave.Accounts

  def mount(_params, %{"user_id" => user_id}, socket) do
    {:ok, assign(socket, :current_user, Accounts.get_user!(user_id))}
  end

  def handle_event("edit", _session, socket) do
    {:noreply, redirect(socket, to: ~p"/users/:id/edit")}
  end

  def render(assigns) do
    ~H"""
    <div class="card mx-auto max-w-md rounded-tr-3xl rounded-lg shadow-lg shadow-blue-500/40">
      <div class=" p-4">
        <h3 class="text-xl font-medium text-gray-900">
          <strong>@<%= @current_user.username %></strong>
        </h3>
        <p class="mt-1 text-zinc-900"><%= @current_user.email %></p>
      </div>
    </div>
    """
  end
end
