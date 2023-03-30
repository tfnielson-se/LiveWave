defmodule Livewave.RoomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Livewave.Rooms` context.
  """

  @doc """
  Generate a chatroom.
  """
  def chatroom_fixture(attrs \\ %{}) do
    {:ok, chatroom} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Livewave.Rooms.create_chatroom()

    chatroom
  end

  @doc """
  Generate a forum.
  """
  def forum_fixture(attrs \\ %{}) do
    {:ok, forum} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Livewave.Rooms.create_forum()

    forum
  end
end
