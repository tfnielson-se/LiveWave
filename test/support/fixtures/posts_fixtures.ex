defmodule Livewave.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Livewave.Posts` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        body: "some body"
      })
      |> Livewave.Posts.create_message()

    message
  end
end
