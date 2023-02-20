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
end
