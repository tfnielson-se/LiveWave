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

  describe "forums" do
    alias Livewave.Rooms.Forum

    import Livewave.RoomsFixtures

    @invalid_attrs %{name: nil}

    test "list_forums/0 returns all forums" do
      forum = forum_fixture()
      assert Rooms.list_forums() == [forum]
    end

    test "get_forum!/1 returns the forum with given id" do
      forum = forum_fixture()
      assert Rooms.get_forum!(forum.id) == forum
    end

    test "create_forum/1 with valid data creates a forum" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Forum{} = forum} = Rooms.create_forum(valid_attrs)
      assert forum.name == "some name"
    end

    test "create_forum/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_forum(@invalid_attrs)
    end

    test "update_forum/2 with valid data updates the forum" do
      forum = forum_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Forum{} = forum} = Rooms.update_forum(forum, update_attrs)
      assert forum.name == "some updated name"
    end

    test "update_forum/2 with invalid data returns error changeset" do
      forum = forum_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_forum(forum, @invalid_attrs)
      assert forum == Rooms.get_forum!(forum.id)
    end

    test "delete_forum/1 deletes the forum" do
      forum = forum_fixture()
      assert {:ok, %Forum{}} = Rooms.delete_forum(forum)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_forum!(forum.id) end
    end

    test "change_forum/1 returns a forum changeset" do
      forum = forum_fixture()
      assert %Ecto.Changeset{} = Rooms.change_forum(forum)
    end
  end
end
