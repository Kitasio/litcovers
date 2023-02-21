defmodule Litcovers.Payments.Yookassa.Helpers do
  def transaction_from_yookassa(body) do
    %{
      "amount" => %{
        "value" => amount,
        "currency" => currency
      },
      "id" => id,
      "status" => status,
      "paid" => paid
    } = body

    %{
      amount: amount |> String.split(".") |> List.first() |> String.to_integer(),
      currency: currency,
      tnx_id: id,
      status: status,
      paid: paid,
      payment_service: "yookassa",
      description: "Buying litcoins"
    }
  end

  def calculate_litcoins(amount) when is_integer(amount) do
    price = 390
    cond do
      amount >= 5850 ->
        div(amount, price) + 10

      amount >= 4680 ->
        div(amount, price) + 5

      amount >= 3510 ->
        div(amount, price) + 3

      amount >= 1950 ->
        div(amount, price) + 2

      amount >= 1170 ->
        div(amount, price) + 1

      true ->
        div(amount, price)
    end
  end
end
