defmodule LivewaveWeb.PageController do
  use LivewaveWeb, :controller

  # plug LivewaveWeb.Plugs.RequireAuth

  def home(socket, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # assign(socket, :user, Accounts.list_users )
    # IO.inspect(" page contr-------->")
    # IO.inspect(socket.assigns)
    render(socket, :home, layout: false)
  end
end
