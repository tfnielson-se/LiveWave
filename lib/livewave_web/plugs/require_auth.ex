defmodule LivewaveWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller
  # this is key to redirect
  use LivewaveWeb, :verified_routes

  def init(_params) do
  end

  def call(socket, _params) do
    if socket.assigns.user do
      socket
    else
      socket
      |> put_flash(:error, "You must be Logged in")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end
end
