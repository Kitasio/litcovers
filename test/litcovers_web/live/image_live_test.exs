defmodule LitcoversWeb.ImageLiveTest do
  use LitcoversWeb.ConnCase

  import Phoenix.LiveViewTest
  import Litcovers.MediaFixtures

  @create_attrs %{
    character_gender: "some character_gender",
    completed: true,
    description: "some description",
    height: 42,
    prompt: "some prompt",
    url: "some url",
    width: 42
  }
  @update_attrs %{
    character_gender: "some updated character_gender",
    completed: false,
    description: "some updated description",
    height: 43,
    prompt: "some updated prompt",
    url: "some updated url",
    width: 43
  }
  @invalid_attrs %{
    character_gender: nil,
    completed: false,
    description: nil,
    height: nil,
    prompt: nil,
    url: nil,
    width: nil
  }

  defp create_image(_) do
    image = image_fixture()
    %{image: image}
  end

  describe "Index" do
    setup [:create_image]

    test "lists all images", %{conn: conn, image: image} do
      {:ok, _index_live, html} = live(conn, ~p"/images")

      assert html =~ "Listing Images"
      assert html =~ image.character_gender
    end

    test "saves new image", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/images")

      assert index_live |> element("a", "New Image") |> render_click() =~
               "New Image"

      assert_patch(index_live, ~p"/images/new")

      assert index_live
             |> form("#image-form", image: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#image-form", image: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/images")

      assert html =~ "Image created successfully"
      assert html =~ "some character_gender"
    end

    test "updates image in listing", %{conn: conn, image: image} do
      {:ok, index_live, _html} = live(conn, ~p"/images")

      assert index_live |> element("#images-#{image.id} a", "Edit") |> render_click() =~
               "Edit Image"

      assert_patch(index_live, ~p"/images/#{image}/edit")

      assert index_live
             |> form("#image-form", image: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#image-form", image: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/images")

      assert html =~ "Image updated successfully"
      assert html =~ "some updated character_gender"
    end

    test "deletes image in listing", %{conn: conn, image: image} do
      {:ok, index_live, _html} = live(conn, ~p"/images")

      assert index_live |> element("#images-#{image.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#image-#{image.id}")
    end
  end

  describe "Show" do
    setup [:create_image]

    test "displays image", %{conn: conn, image: image} do
      {:ok, _show_live, html} = live(conn, ~p"/images/#{image}")

      assert html =~ "Show Image"
      assert html =~ image.character_gender
    end

    test "updates image within modal", %{conn: conn, image: image} do
      {:ok, show_live, _html} = live(conn, ~p"/images/#{image}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Image"

      assert_patch(show_live, ~p"/images/#{image}/show/edit")

      assert show_live
             |> form("#image-form", image: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#image-form", image: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/images/#{image}")

      assert html =~ "Image updated successfully"
      assert html =~ "some updated character_gender"
    end
  end
end
