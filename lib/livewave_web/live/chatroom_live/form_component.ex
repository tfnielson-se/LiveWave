defmodule LivewaveWeb.ChatroomLive.FormComponent do
  use LivewaveWeb, :live_component

  alias Livewave.Rooms

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Enter chatroom name</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="chatroom-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Chatroom</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{chatroom: chatroom} = assigns, socket) do
    changeset = Rooms.change_chatroom(chatroom)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"chatroom" => chatroom_params}, socket) do
    changeset =
      socket.assigns.chatroom
      |> Rooms.change_chatroom(chatroom_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"chatroom" => chatroom_params}, socket) do
    save_chatroom(socket, socket.assigns.action, chatroom_params)
  end

  defp save_chatroom(socket, :edit, chatroom_params) do
    IO.inspect("-------->")
    IO.inspect(chatroom_params)
    case Rooms.update_chatroom(socket.assigns.chatroom, chatroom_params) do
      {:ok, chatroom} ->
        notify_parent({:saved, chatroom})

        {:noreply,
        socket
          |> put_flash(:info, "Chatroom updated successfully")
          |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_chatroom(socket, :new, chatroom_params) do
    case Rooms.create_chatroom(chatroom_params) do
      {:ok, chatroom} ->
        notify_parent({:saved, chatroom})

        {:noreply,
         socket
         |> put_flash(:info, "Chatroom created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
