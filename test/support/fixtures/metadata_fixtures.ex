defmodule Litcovers.MetadataFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Litcovers.Metadata` context.
  """

  @doc """
  Generate a prompt.
  """
  def prompt_fixture(attrs \\ %{}) do
    {:ok, prompt} =
      attrs
      |> Enum.into(%{
        image_url: "some image_url",
        name: "some name",
        realm: :fantasy,
        sentiment: :positive,
        style_prompt: "some style_prompt",
        type: :setting
      })
      |> Litcovers.Metadata.create_prompt()

    prompt
  end
end
