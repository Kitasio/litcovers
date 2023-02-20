defmodule Litcovers.Payments.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, :integer
    field :currency, :string
    field :description, :string
    field :payment_service, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:amount, :currency, :payment_service, :description])
    |> validate_required([:amount, :currency, :payment_service, :description])
  end
end
