defmodule Livewave.RoomsTest do
  use Livewave.DataCase

  alias Livewave.Rooms

  describe "chatrooms" do
    alias Livewave.Rooms.Chatroom

    import Livewave.RoomsFixtures

    @invalid_attrs %{name: nil}

    test "list_chatrooms/0 returns all chatrooms" do
      chatroom = chatroom_fixture()
      assert Rooms.list_chatrooms() == [chatroom]
    end

    test "get_chatroom!/1 returns the chatroom with given id" do
      chatroom = chatroom_fixture()
      assert Rooms.get_chatroom!(chatroom.id) == chatroom
    end

    test "create_chatroom/1 with valid data creates a chatroom" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Chatroom{} = chatroom} = Rooms.create_chatroom(valid_attrs)
      assert chatroom.name == "some name"
    end

    test "create_chatroom/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_chatroom(@invalid_attrs)
    end

    test "update_chatroom/2 with valid data updates the chatroom" do
      chatroom = chatroom_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Chatroom{} = chatroom} = Rooms.update_chatroom(chatroom, update_attrs)
      assert chatroom.name == "some updated name"
    end

    test "update_chatroom/2 with invalid data returns error changeset" do
      chatroom = chatroom_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_chatroom(chatroom, @invalid_attrs)
      assert chatroom == Rooms.get_chatroom!(chatroom.id)
    end

    test "delete_chatroom/1 deletes the chatroom" do
      chatroom = chatroom_fixture()
      assert {:ok, %Chatroom{}} = Rooms.delete_chatroom(chatroom)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_chatroom!(chatroom.id) end
    end

    test "change_chatroom/1 returns a chatroom changeset" do
      chatroom = chatroom_fixture()
      assert %Ecto.Changeset{} = Rooms.change_chatroom(chatroom)
    end
  end
end
