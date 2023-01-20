defmodule Litcovers.Media.Image do
  use Ecto.Schema
  import Ecto.Changeset

  schema "images" do
    field :character_gender, :string
    field :completed, :boolean, default: false
    field :description, :string
    field :height, :integer
    field :prompt, :string
    field :url, :string
    field :width, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:url, :description, :completed, :width, :height, :prompt, :character_gender])
    |> validate_required([:url, :description, :completed, :width, :height, :prompt, :character_gender])
  end
end
