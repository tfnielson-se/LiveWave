defmodule LivewaveWeb.AuthController do
  use LivewaveWeb, :controller
  require Logger

  alias Livewave.Repo
  alias Livewave.Accounts.User

  plug(Ueberauth)

  def callback(%{assigns: %{ueberauth_auth: auth}} = socket, _params) do
    IO.inspect("----->")

    user_params = %{
      email: auth.info.email,
      username: auth.info.nickname,
      image: auth.info.image,
      token: auth.credentials.token,
      provider: "github"
    }

    IO.inspect(user_params)
    changeset = User.changeset(%User{}, user_params)

    signin(socket, changeset)
  end

  defp signin(socket, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        socket
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Welcome back #{user.username}!")
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
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)

      user ->
        {:ok, user}
    end
  end
end
