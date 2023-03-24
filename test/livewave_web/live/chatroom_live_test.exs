defmodule LivewaveWeb.ChatroomLiveTest do
  use LivewaveWeb.ConnCase

  import Phoenix.LiveViewTest
  import Livewave.RoomsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_chatroom(_) do
    chatroom = chatroom_fixture()
    %{chatroom: chatroom}
  end

  describe "Index" do
    setup [:create_chatroom]

    test "lists all chatrooms", %{conn: conn, chatroom: chatroom} do
      {:ok, _index_live, html} = live(conn, ~p"/chatrooms")

      assert html =~ "Listing Chatrooms"
      assert html =~ chatroom.name
    end

    test "saves new chatroom", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/chatrooms")

      assert index_live |> element("a", "New Chatroom") |> render_click() =~
               "New Chatroom"

      assert_patch(index_live, ~p"/chatrooms/new")

      assert index_live
             |> form("#chatroom-form", chatroom: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#chatroom-form", chatroom: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/chatrooms")

      html = render(index_live)
      assert html =~ "Chatroom created successfully"
      assert html =~ "some name"
    end

    test "updates chatroom in listing", %{conn: conn, chatroom: chatroom} do
      {:ok, index_live, _html} = live(conn, ~p"/chatrooms")

      assert index_live |> element("#chatrooms-#{chatroom.id} a", "Edit") |> render_click() =~
               "Edit Chatroom"

      assert_patch(index_live, ~p"/chatrooms/#{chatroom}/edit")

      assert index_live
             |> form("#chatroom-form", chatroom: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#chatroom-form", chatroom: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/chatrooms")

      html = render(index_live)
      assert html =~ "Chatroom updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes chatroom in listing", %{conn: conn, chatroom: chatroom} do
      {:ok, index_live, _html} = live(conn, ~p"/chatrooms")

      assert index_live |> element("#chatrooms-#{chatroom.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#chatrooms-#{chatroom.id}")
    end
  end

  describe "Show" do
    setup [:create_chatroom]

    test "displays chatroom", %{conn: conn, chatroom: chatroom} do
      {:ok, _show_live, html} = live(conn, ~p"/chatrooms/#{chatroom}")

      assert html =~ "Show Chatroom"
      assert html =~ chatroom.name
    end

    test "updates chatroom within modal", %{conn: conn, chatroom: chatroom} do
      {:ok, show_live, _html} = live(conn, ~p"/chatrooms/#{chatroom}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Chatroom"

      assert_patch(show_live, ~p"/chatrooms/#{chatroom}/show/edit")

      assert show_live
             |> form("#chatroom-form", chatroom: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#chatroom-form", chatroom: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/chatrooms/#{chatroom}")

      html = render(show_live)
      assert html =~ "Chatroom updated successfully"
      assert html =~ "some updated name"
    end
  end
end
