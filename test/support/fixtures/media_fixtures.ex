defmodule Litcovers.MediaFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Litcovers.Media` context.
  """

  @doc """
  Generate a image.
  """
  def image_fixture(attrs \\ %{}) do
    {:ok, image} =
      attrs
      |> Enum.into(%{
        character_gender: "some character_gender",
        completed: true,
        description: "some description",
        height: 42,
        prompt: "some prompt",
        url: "some url",
        width: 42
      })
      |> Litcovers.Media.create_image()

    image
  end
end
