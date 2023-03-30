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
    Chatroom
    |> Repo.all()
    |> Repo.preload([:messages, :users])
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

  alias Livewave.Rooms.Forum

  @doc """
  Returns the list of forums.

  ## Examples

      iex> list_forums()
      [%Forum{}, ...]

  """
  def list_forums do
    Repo.all(Forum)
  end

  @doc """
  Gets a single forum.

  Raises `Ecto.NoResultsError` if the Forum does not exist.

  ## Examples

      iex> get_forum!(123)
      %Forum{}

      iex> get_forum!(456)
      ** (Ecto.NoResultsError)

  """
  def get_forum!(id), do: Repo.get!(Forum, id)

  @doc """
  Creates a forum.

  ## Examples

      iex> create_forum(%{field: value})
      {:ok, %Forum{}}

      iex> create_forum(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_forum(attrs \\ %{}) do
    %Forum{}
    |> Forum.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a forum.

  ## Examples

      iex> update_forum(forum, %{field: new_value})
      {:ok, %Forum{}}

      iex> update_forum(forum, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_forum(%Forum{} = forum, attrs) do
    forum
    |> Forum.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a forum.

  ## Examples

      iex> delete_forum(forum)
      {:ok, %Forum{}}

      iex> delete_forum(forum)
      {:error, %Ecto.Changeset{}}

  """
  def delete_forum(%Forum{} = forum) do
    Repo.delete(forum)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking forum changes.

  ## Examples

      iex> change_forum(forum)
      %Ecto.Changeset{data: %Forum{}}

  """
  def change_forum(%Forum{} = forum, attrs \\ %{}) do
    Forum.changeset(forum, attrs)
  end
end
