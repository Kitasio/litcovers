defmodule LitcoversWeb.PlaceholderLiveTest do
  use LitcoversWeb.ConnCase

  import Phoenix.LiveViewTest
  import Litcovers.MetadataFixtures

  @create_attrs %{author: "some author", description: "some description", title: "some title"}
  @update_attrs %{author: "some updated author", description: "some updated description", title: "some updated title"}
  @invalid_attrs %{author: nil, description: nil, title: nil}

  defp create_placeholder(_) do
    placeholder = placeholder_fixture()
    %{placeholder: placeholder}
  end

  describe "Index" do
    setup [:create_placeholder]

    test "lists all placeholders", %{conn: conn, placeholder: placeholder} do
      {:ok, _index_live, html} = live(conn, ~p"/placeholders")

      assert html =~ "Listing Placeholders"
      assert html =~ placeholder.author
    end

    test "saves new placeholder", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/placeholders")

      assert index_live |> element("a", "New Placeholder") |> render_click() =~
               "New Placeholder"

      assert_patch(index_live, ~p"/placeholders/new")

      assert index_live
             |> form("#placeholder-form", placeholder: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#placeholder-form", placeholder: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/placeholders")

      assert html =~ "Placeholder created successfully"
      assert html =~ "some author"
    end

    test "updates placeholder in listing", %{conn: conn, placeholder: placeholder} do
      {:ok, index_live, _html} = live(conn, ~p"/placeholders")

      assert index_live |> element("#placeholders-#{placeholder.id} a", "Edit") |> render_click() =~
               "Edit Placeholder"

      assert_patch(index_live, ~p"/placeholders/#{placeholder}/edit")

      assert index_live
             |> form("#placeholder-form", placeholder: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#placeholder-form", placeholder: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/placeholders")

      assert html =~ "Placeholder updated successfully"
      assert html =~ "some updated author"
    end

    test "deletes placeholder in listing", %{conn: conn, placeholder: placeholder} do
      {:ok, index_live, _html} = live(conn, ~p"/placeholders")

      assert index_live |> element("#placeholders-#{placeholder.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#placeholder-#{placeholder.id}")
    end
  end

  describe "Show" do
    setup [:create_placeholder]

    test "displays placeholder", %{conn: conn, placeholder: placeholder} do
      {:ok, _show_live, html} = live(conn, ~p"/placeholders/#{placeholder}")

      assert html =~ "Show Placeholder"
      assert html =~ placeholder.author
    end

    test "updates placeholder within modal", %{conn: conn, placeholder: placeholder} do
      {:ok, show_live, _html} = live(conn, ~p"/placeholders/#{placeholder}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Placeholder"

      assert_patch(show_live, ~p"/placeholders/#{placeholder}/show/edit")

      assert show_live
             |> form("#placeholder-form", placeholder: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#placeholder-form", placeholder: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/placeholders/#{placeholder}")

      assert html =~ "Placeholder updated successfully"
      assert html =~ "some updated author"
    end
  end
end
