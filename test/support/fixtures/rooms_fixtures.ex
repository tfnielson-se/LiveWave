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
end
