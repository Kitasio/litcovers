defmodule Litcovers.MetadataTest do
  use Litcovers.DataCase

  alias Litcovers.Metadata

  describe "prompts" do
    alias Litcovers.Metadata.Prompt

    import Litcovers.MetadataFixtures

    @invalid_attrs %{image_url: nil, name: nil, realm: nil, sentiment: nil, style_prompt: nil, type: nil}

    test "list_prompts/0 returns all prompts" do
      prompt = prompt_fixture()
      assert Metadata.list_prompts() == [prompt]
    end

    test "get_prompt!/1 returns the prompt with given id" do
      prompt = prompt_fixture()
      assert Metadata.get_prompt!(prompt.id) == prompt
    end

    test "create_prompt/1 with valid data creates a prompt" do
      valid_attrs = %{image_url: "some image_url", name: "some name", realm: :fantasy, sentiment: :positive, style_prompt: "some style_prompt", type: :setting}

      assert {:ok, %Prompt{} = prompt} = Metadata.create_prompt(valid_attrs)
      assert prompt.image_url == "some image_url"
      assert prompt.name == "some name"
      assert prompt.realm == :fantasy
      assert prompt.sentiment == :positive
      assert prompt.style_prompt == "some style_prompt"
      assert prompt.type == :setting
    end

    test "create_prompt/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Metadata.create_prompt(@invalid_attrs)
    end

    test "update_prompt/2 with valid data updates the prompt" do
      prompt = prompt_fixture()
      update_attrs = %{image_url: "some updated image_url", name: "some updated name", realm: :realism, sentiment: :neutral, style_prompt: "some updated style_prompt", type: :portrait}

      assert {:ok, %Prompt{} = prompt} = Metadata.update_prompt(prompt, update_attrs)
      assert prompt.image_url == "some updated image_url"
      assert prompt.name == "some updated name"
      assert prompt.realm == :realism
      assert prompt.sentiment == :neutral
      assert prompt.style_prompt == "some updated style_prompt"
      assert prompt.type == :portrait
    end

    test "update_prompt/2 with invalid data returns error changeset" do
      prompt = prompt_fixture()
      assert {:error, %Ecto.Changeset{}} = Metadata.update_prompt(prompt, @invalid_attrs)
      assert prompt == Metadata.get_prompt!(prompt.id)
    end

    test "delete_prompt/1 deletes the prompt" do
      prompt = prompt_fixture()
      assert {:ok, %Prompt{}} = Metadata.delete_prompt(prompt)
      assert_raise Ecto.NoResultsError, fn -> Metadata.get_prompt!(prompt.id) end
    end

    test "change_prompt/1 returns a prompt changeset" do
      prompt = prompt_fixture()
      assert %Ecto.Changeset{} = Metadata.change_prompt(prompt)
    end
  end

  describe "placeholders" do
    alias Litcovers.Metadata.Placeholder

    import Litcovers.MetadataFixtures

    @invalid_attrs %{author: nil, description: nil, title: nil}

    test "list_placeholders/0 returns all placeholders" do
      placeholder = placeholder_fixture()
      assert Metadata.list_placeholders() == [placeholder]
    end

    test "get_placeholder!/1 returns the placeholder with given id" do
      placeholder = placeholder_fixture()
      assert Metadata.get_placeholder!(placeholder.id) == placeholder
    end

    test "create_placeholder/1 with valid data creates a placeholder" do
      valid_attrs = %{author: "some author", description: "some description", title: "some title"}

      assert {:ok, %Placeholder{} = placeholder} = Metadata.create_placeholder(valid_attrs)
      assert placeholder.author == "some author"
      assert placeholder.description == "some description"
      assert placeholder.title == "some title"
    end

    test "create_placeholder/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Metadata.create_placeholder(@invalid_attrs)
    end

    test "update_placeholder/2 with valid data updates the placeholder" do
      placeholder = placeholder_fixture()
      update_attrs = %{author: "some updated author", description: "some updated description", title: "some updated title"}

      assert {:ok, %Placeholder{} = placeholder} = Metadata.update_placeholder(placeholder, update_attrs)
      assert placeholder.author == "some updated author"
      assert placeholder.description == "some updated description"
      assert placeholder.title == "some updated title"
    end

    test "update_placeholder/2 with invalid data returns error changeset" do
      placeholder = placeholder_fixture()
      assert {:error, %Ecto.Changeset{}} = Metadata.update_placeholder(placeholder, @invalid_attrs)
      assert placeholder == Metadata.get_placeholder!(placeholder.id)
    end

    test "delete_placeholder/1 deletes the placeholder" do
      placeholder = placeholder_fixture()
      assert {:ok, %Placeholder{}} = Metadata.delete_placeholder(placeholder)
      assert_raise Ecto.NoResultsError, fn -> Metadata.get_placeholder!(placeholder.id) end
    end

    test "change_placeholder/1 returns a placeholder changeset" do
      placeholder = placeholder_fixture()
      assert %Ecto.Changeset{} = Metadata.change_placeholder(placeholder)
    end
  end
end
