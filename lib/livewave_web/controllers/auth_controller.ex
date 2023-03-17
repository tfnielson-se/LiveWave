defmodule LivewaveWeb.AuthController do
  use LivewaveWeb, :controller
  plug(Ueberauth)

  alias Livewave.Repo
  alias Livewave.Accounts.User

  # def callback(conn, params) do
  #   IO.inspect("--------->")
  #   IO.inspect(conn.assigns)
  #   IO.inspect("--------->")
  #   IO.inspect(params)
  # end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    IO.inspect("--------->")
    IO.inspect(auth.credentials.token)
    user_params = %{
      email: auth.info.email,
      username: auth.info.nickname,
      token: auth.credentials.token,
      provider: "github",
    }
    changeset = User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: ~p"/users")
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: ~p"/")
    end
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: ~p"/")
  end

  defp insert_or_update_user(changeset) do
    IO.inspect(changeset)
    case Repo.get_by(User, username: changeset.changes.username) do
      nil ->
        Repo.insert(changeset)

      user ->
        {:ok, user}
    end
  end
end
