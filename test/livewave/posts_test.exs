defmodule Livewave.PostsTest do
  use Livewave.DataCase

  alias Livewave.Posts

  describe "messages" do
    alias Livewave.Posts.Message

    import Livewave.PostsFixtures

    @invalid_attrs %{body: nil}

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Posts.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Posts.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{body: "some body"}

      assert {:ok, %Message{} = message} = Posts.create_message(valid_attrs)
      assert message.body == "some body"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      update_attrs = %{body: "some updated body"}

      assert {:ok, %Message{} = message} = Posts.update_message(message, update_attrs)
      assert message.body == "some updated body"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_message(message, @invalid_attrs)
      assert message == Posts.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Posts.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Posts.change_message(message)
    end
  end

  describe "comments" do
    alias Livewave.Posts.Comment

    import Livewave.PostsFixtures

    @invalid_attrs %{body: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Posts.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Posts.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{body: "some body"}

      assert {:ok, %Comment{} = comment} = Posts.create_comment(valid_attrs)
      assert comment.body == "some body"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{body: "some updated body"}

      assert {:ok, %Comment{} = comment} = Posts.update_comment(comment, update_attrs)
      assert comment.body == "some updated body"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_comment(comment, @invalid_attrs)
      assert comment == Posts.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Posts.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Posts.change_comment(comment)
    end
  end
end
