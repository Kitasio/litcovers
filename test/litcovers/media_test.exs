defmodule Litcovers.MediaTest do
  use Litcovers.DataCase

  alias Litcovers.Media

  describe "images" do
    alias Litcovers.Media.Image

    import Litcovers.MediaFixtures

    @invalid_attrs %{
      character_gender: nil,
      completed: nil,
      description: nil,
      height: nil,
      prompt: nil,
      url: nil,
      width: nil
    }

    test "list_images/0 returns all images" do
      image = image_fixture()
      assert Media.list_images() == [image]
    end

    test "get_image!/1 returns the image with given id" do
      image = image_fixture()
      assert Media.get_image!(image.id) == image
    end

    test "create_image/1 with valid data creates a image" do
      valid_attrs = %{
        character_gender: "some character_gender",
        completed: true,
        description: "some description",
        height: 42,
        prompt: "some prompt",
        url: "some url",
        width: 42
      }

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

      update_attrs = %{
        character_gender: "some updated character_gender",
        completed: false,
        description: "some updated description",
        height: 43,
        prompt: "some updated prompt",
        url: "some updated url",
        width: 43
      }

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

  describe "ideas" do
    alias Litcovers.Media.Idea

    import Litcovers.MediaFixtures

    @invalid_attrs %{idea: nil}

    test "list_ideas/0 returns all ideas" do
      idea = idea_fixture()
      assert Media.list_ideas() == [idea]
    end

    test "get_idea!/1 returns the idea with given id" do
      idea = idea_fixture()
      assert Media.get_idea!(idea.id) == idea
    end

    test "create_idea/1 with valid data creates a idea" do
      valid_attrs = %{idea: "some idea"}

      assert {:ok, %Idea{} = idea} = Media.create_idea(valid_attrs)
      assert idea.idea == "some idea"
    end

    test "create_idea/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Media.create_idea(@invalid_attrs)
    end

    test "update_idea/2 with valid data updates the idea" do
      idea = idea_fixture()
      update_attrs = %{idea: "some updated idea"}

      assert {:ok, %Idea{} = idea} = Media.update_idea(idea, update_attrs)
      assert idea.idea == "some updated idea"
    end

    test "update_idea/2 with invalid data returns error changeset" do
      idea = idea_fixture()
      assert {:error, %Ecto.Changeset{}} = Media.update_idea(idea, @invalid_attrs)
      assert idea == Media.get_idea!(idea.id)
    end

    test "delete_idea/1 deletes the idea" do
      idea = idea_fixture()
      assert {:ok, %Idea{}} = Media.delete_idea(idea)
      assert_raise Ecto.NoResultsError, fn -> Media.get_idea!(idea.id) end
    end

    test "change_idea/1 returns a idea changeset" do
      idea = idea_fixture()
      assert %Ecto.Changeset{} = Media.change_idea(idea)
    end
  end

  describe "covers" do
    alias Litcovers.Media.Cover

    import Litcovers.MediaFixtures

    @invalid_attrs %{seen: nil, url: nil}

    test "list_covers/0 returns all covers" do
      cover = cover_fixture()
      assert Media.list_covers() == [cover]
    end

    test "get_cover!/1 returns the cover with given id" do
      cover = cover_fixture()
      assert Media.get_cover!(cover.id) == cover
    end

    test "create_cover/1 with valid data creates a cover" do
      valid_attrs = %{seen: true, url: "some url"}

      assert {:ok, %Cover{} = cover} = Media.create_cover(valid_attrs)
      assert cover.seen == true
      assert cover.url == "some url"
    end

    test "create_cover/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Media.create_cover(@invalid_attrs)
    end

    test "update_cover/2 with valid data updates the cover" do
      cover = cover_fixture()
      update_attrs = %{seen: false, url: "some updated url"}

      assert {:ok, %Cover{} = cover} = Media.update_cover(cover, update_attrs)
      assert cover.seen == false
      assert cover.url == "some updated url"
    end

    test "update_cover/2 with invalid data returns error changeset" do
      cover = cover_fixture()
      assert {:error, %Ecto.Changeset{}} = Media.update_cover(cover, @invalid_attrs)
      assert cover == Media.get_cover!(cover.id)
    end

    test "delete_cover/1 deletes the cover" do
      cover = cover_fixture()
      assert {:ok, %Cover{}} = Media.delete_cover(cover)
      assert_raise Ecto.NoResultsError, fn -> Media.get_cover!(cover.id) end
    end

    test "change_cover/1 returns a cover changeset" do
      cover = cover_fixture()
      assert %Ecto.Changeset{} = Media.change_cover(cover)
    end
  end
end
