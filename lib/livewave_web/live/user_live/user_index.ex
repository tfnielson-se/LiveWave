defmodule LivewaveWeb.UserLive.UserIndex do
  use LivewaveWeb, :live_view

  require Logger

  alias Livewave.Repo
  alias Livewave.Accounts
  alias Livewave.Accounts.User

  alias Livewave.Rooms
  alias Livewave.Rooms.Chatroom

  alias Livewave.Posts
  alias Livewave.Posts.Message

  def mount(_params, %{"user_id" => user_id}, socket) do
    if connected?(socket) do
      # IO.inspect(socket.assigns)
    end
    current_user = Repo.get(User, user_id)
    {:ok, assign(socket, users: Accounts.list_users(), current_user: current_user)}
  end

  @implt true

  def handle_event("new-chat", %{"value" => user_id}, socket) do
    current_user = socket.assigns.current_user

    user = Repo.get(User, user_id)

    {:ok, new_room} = Rooms.create_chatroom(%{name: "Chat with: #{user.username}"})
    IO.inspect("------->")
    new_post = Posts.create_message(%{body: "hello", user_id: current_user.id, chatroom_id: new_room.id})
    IO.inspect(new_post)
    # {:noreply, redirect(socket, to: ~p"/chats/#{new_room.id}")}
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="container w-full px-4 mx-auto">
    <div class="flex flex-col">
        <div class="-mx-4 -my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
            <div class="inline-block min-w-full py-2 align-middle md:px-6 lg:px-8">
                <div class="overflow-hidden border border-gray-200 dark:border-gray-700 md:rounded-lg">
                    <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
                        <thead class="bg-gray-50 dark:bg-gray-800">
                            <tr>
                                <th scope="col" class="py-3.5 px-4 text-sm font-normal text-left rtl:text-right text-gray-500 dark:text-gray-400">
                                    <div class="flex items-center gap-x-3">
                                            <span>ID#</span>

                                    </div>
                                </th>

                                <th scope="col" class="px-4 py-3.5 text-sm font-normal text-left rtl:text-right text-gray-500 dark:text-gray-400">
                                    Status
                                </th>

                                <th scope="col" class="px-4 py-3.5 text-sm font-normal text-left rtl:text-right text-gray-500 dark:text-gray-400">
                                    users
                                </th>

                                <th scope="col" class="px-4 py-3.5 text-sm font-normal text-left rtl:text-right text-gray-500 dark:text-gray-400">
                                    Customer
                                </th>


                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200 dark:divide-gray-700 dark:bg-gray-900">
    <%= for user <- @users do %>
                            <tr>
                                <td class="px-4 py-4 text-sm font-medium text-gray-700 dark:text-gray-200 whitespace-nowrap">
                                    <div class="inline-flex items-center gap-x-3">

                                        <span>
                                        <%= user.id %>
                                        </span>
                                    </div>
                                </td>
                                <td class="px-4 py-4 text-sm font-medium text-gray-700 whitespace-nowrap">
                                    <div class="inline-flex items-center px-3 py-1 text-gray-500 rounded-full gap-x-2 bg-gray-100/60 dark:bg-green-600">

                                        <button phx-click="new-chat" value={"#{user.id}"}
                                        name={""}
                                        class="text-sm font-normal text-white">Chat</button>
                                    </div>
                                </td>
                                <td class="px-4 py-4 text-sm text-gray-500 dark:text-gray-300 whitespace-nowrap">
                                    <div class="flex items-center gap-x-2">
                                        <div>
                                            <h2 class="text-sm font-medium text-gray-800 dark:text-white "><%= user.username %></h2>
                                            <p class="text-xs font-normal text-gray-600 dark:text-gray-400">
                                            <%= user.email %>
                                            </p>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-4 py-4 text-sm whitespace-nowrap">
                                    <div class="flex items-center gap-x-6">
                                        <.link href={~p"/users/#{user.id}"} class="text-blue-500 transition-colors duration-200 hover:text-indigo-500 focus:outline-none"> View Profile </.link>
                                    </div>
                                </td>
                            </tr>
    <% end %>
    </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    </section>
    """
  end
end
