defmodule Livewave.Rooms do
  @moduledoc """
  The Rooms context.
  """

  import Ecto.Query, warn: false
  alias Livewave.Repo

  alias Livewave.Rooms.Chatroom

  @doc """
  Returns the list of chatrooms.

  ## Examples

      iex> list_chatrooms()
      [%Chatroom{}, ...]

  """
  def list_chatrooms do
    Repo.all(Chatroom)
  end

  @doc """
  Gets a single chatroom.

  Raises `Ecto.NoResultsError` if the Chatroom does not exist.

  ## Examples

      iex> get_chatroom!(123)
      %Chatroom{}

      iex> get_chatroom!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chatroom!(id), do: Repo.get!(Chatroom, id)

  @doc """
  Creates a chatroom.

  ## Examples

      iex> create_chatroom(%{field: value})
      {:ok, %Chatroom{}}

      iex> create_chatroom(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chatroom(attrs \\ %{}) do
    %Chatroom{}
    |> Chatroom.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chatroom.

  ## Examples

      iex> update_chatroom(chatroom, %{field: new_value})
      {:ok, %Chatroom{}}

      iex> update_chatroom(chatroom, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chatroom(%Chatroom{} = chatroom, attrs) do
    chatroom
    |> Chatroom.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a chatroom.

  ## Examples

      iex> delete_chatroom(chatroom)
      {:ok, %Chatroom{}}

      iex> delete_chatroom(chatroom)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chatroom(%Chatroom{} = chatroom) do
    Repo.delete(chatroom)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chatroom changes.

  ## Examples

      iex> change_chatroom(chatroom)
      %Ecto.Changeset{data: %Chatroom{}}

  """
  def change_chatroom(%Chatroom{} = chatroom, attrs \\ %{}) do
    Chatroom.changeset(chatroom, attrs)
  end
end
