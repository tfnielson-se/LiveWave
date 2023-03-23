defmodule LivewaveWeb.AuthController do
  use LivewaveWeb, :controller
  plug(Ueberauth)
  require Logger

  alias Livewave.Repo
  alias Livewave.Accounts.User

  # def callback(socket, params) do
  #   IO.inspect("--------->")
  #   IO.inspect(socket.assigns)
  #   IO.inspect("--------->")
  #   IO.inspect(params)
  # end

  def callback(%{assigns: %{ueberauth_auth: auth}} = socket, _params) do
    user_params = %{
      email: auth.info.email,
      username: auth.info.nickname,
      token: auth.credentials.token,
      provider: "github",
    }
    changeset = User.changeset(%User{}, user_params)

    signin(socket, changeset)
  end

  defp signin(socket, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        socket
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Welcome back #{user.username}!")
        # |> IO.inspect()
        |> redirect(to: ~p"/")
      {:error, _reason} ->
        socket
        |> put_flash(:error, "Error signing in")
        |> redirect(to: ~p"/")
    end
  end

  def signout(socket, _params) do
    socket
    |> configure_session(drop: true)
    |> redirect(to: ~p"/")
  end

  defp insert_or_update_user(changeset) do
    # IO.inspect("----->")
    # IO.inspect(changeset.changes.email)
    # IO.inspect(Repo.get_by(User, email: changeset.changes.email))
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)

      user ->
        # IO.inspect(user)
        {:ok, user}
    end
  end
end
