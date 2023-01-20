defmodule Litcovers.MediaTest do
  use Litcovers.DataCase

  alias Litcovers.Media

  describe "images" do
    alias Litcovers.Media.Image

    import Litcovers.MediaFixtures

    @invalid_attrs %{character_gender: nil, completed: nil, description: nil, height: nil, prompt: nil, url: nil, width: nil}

    test "list_images/0 returns all images" do
      image = image_fixture()
      assert Media.list_images() == [image]
    end

    test "get_image!/1 returns the image with given id" do
      image = image_fixture()
      assert Media.get_image!(image.id) == image
    end

    test "create_image/1 with valid data creates a image" do
      valid_attrs = %{character_gender: "some character_gender", completed: true, description: "some description", height: 42, prompt: "some prompt", url: "some url", width: 42}

      assert {:ok, %Image{} = image} = Media.create_image(valid_attrs)
      assert image.character_gender == "some character_gender"
      assert image.completed == true
      assert image.description == "some description"
      assert image.height == 42
      assert image.prompt == "some prompt"
      assert image.url == "some url"
      assert image.width == 42
    end

    test "create_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Media.create_image(@invalid_attrs)
    end

    test "update_image/2 with valid data updates the image" do
      image = image_fixture()
      update_attrs = %{character_gender: "some updated character_gender", completed: false, description: "some updated description", height: 43, prompt: "some updated prompt", url: "some updated url", width: 43}

      assert {:ok, %Image{} = image} = Media.update_image(image, update_attrs)
      assert image.character_gender == "some updated character_gender"
      assert image.completed == false
      assert image.description == "some updated description"
      assert image.height == 43
      assert image.prompt == "some updated prompt"
      assert image.url == "some updated url"
      assert image.width == 43
    end

    test "update_image/2 with invalid data returns error changeset" do
      image = image_fixture()
      assert {:error, %Ecto.Changeset{}} = Media.update_image(image, @invalid_attrs)
      assert image == Media.get_image!(image.id)
    end

    test "delete_image/1 deletes the image" do
      image = image_fixture()
      assert {:ok, %Image{}} = Media.delete_image(image)
      assert_raise Ecto.NoResultsError, fn -> Media.get_image!(image.id) end
    end

    test "change_image/1 returns a image changeset" do
      image = image_fixture()
      assert %Ecto.Changeset{} = Media.change_image(image)
    end
  end
end
