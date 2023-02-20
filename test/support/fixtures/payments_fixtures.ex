defmodule Litcovers.PaymentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Litcovers.Payments` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        amount: 42,
        currency: "some currency",
        description: "some description",
        payment_service: "some payment_service"
      })
      |> Litcovers.Payments.create_transaction()

    transaction
  end
end
