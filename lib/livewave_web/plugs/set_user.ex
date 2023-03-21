defmodule LivewaveWeb.Plugs.SetUser do
  import Plug.Conn

  import Phoenix.Controller
  require Logger


  alias Livewave.Repo
  alias Livewave.Accounts.User

  def init(_params) do
  end

  def call(socket, _params) do
    user_id = get_session(socket, :user_id)
    cond do
      user = user_id && Repo.get(User, user_id) ->
        assign(socket, :user, user)
      true ->
        assign(socket, :user, nil)
      end
  end
end
