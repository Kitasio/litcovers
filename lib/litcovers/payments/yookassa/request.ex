defmodule Litcovers.Payments.Yookassa.Request do
  alias Litcovers.Payments.Yookassa
  require Logger

  @derive Jason.Encoder
  defstruct amount: %{
              value: "390.00",
              currency: "RUB"
            },
            capture: true,
            confirmation: %{
              type: "redirect",
              return_url: "https://litcovers.com/images/new"
            },
            description: "Buying litcoins"

  def payment(shop_id, secret_key) do
    endpoint = "https://api.yookassa.ru/v3/payments"

    headers = [
      Authorization: "Basic " <> Base.encode64("#{shop_id}:#{secret_key}"),
      "Content-Type": "application/json",
      "Idempotence-Key": Ecto.UUID.generate()
    ]

    yookassa_params = %Yookassa.Request{
      amount: %{
        value: "390.00",
        currency: "RUB"
      },
      capture: true,
      confirmation: %{
        type: "redirect",
        return_url: "http://localhost:4000/ru/images/new"
      },
      description: "Buying litcoins"
    }

    body = Jason.encode!(yookassa_params)

    case HTTPoison.post(endpoint, body, headers) do
      {:ok, %HTTPoison.Response{body: res_body}} ->
        body = Jason.decode!(res_body)
        {:ok, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("Yookassa error: #{inspect(reason)}")
        {:error, reason}
    end
  end

  def get_payment_status(tnx_id, shop_id, secret_key) do
    endpoint = "https://api.yookassa.ru/v3/payments/#{tnx_id}"

    headers = [
      Authorization: "Basic " <> Base.encode64("#{shop_id}:#{secret_key}")
    ]

    case HTTPoison.get(endpoint, headers) do
      {:ok, %HTTPoison.Response{body: res_body}} ->
        body = Jason.decode!(res_body)
        {:ok, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("Yookassa error: #{inspect(reason)}")
        {:error, reason}
    end
  end
end
