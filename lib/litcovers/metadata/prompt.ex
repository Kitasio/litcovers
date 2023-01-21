defmodule Litcovers.Metadata.Prompt do
  use Ecto.Schema
  import Ecto.Changeset

  schema "prompts" do
    field :image_url, :string
    field :name, :string
    field :realm, Ecto.Enum, values: [:fantasy, :realism, :futurism]
    field :sentiment, Ecto.Enum, values: [:positive, :neutral, :negative]
    field :style_prompt, :string
    field :type, Ecto.Enum, values: [:setting, :portrait, :couple]

    timestamps()
  end

  @doc false
  def changeset(prompt, attrs) do
    prompt
    |> cast(attrs, [:name, :realm, :sentiment, :type, :style_prompt, :image_url])
    |> validate_required([:name, :realm, :sentiment, :type, :style_prompt, :image_url])
  end
end
