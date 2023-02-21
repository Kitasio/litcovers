defmodule LitcoversWeb.TransactionLive.Index do
  use LitcoversWeb, :live_view
  alias Litcovers.Payments
  alias Litcovers.Payments.Yookassa

  def mount(%{"locale" => locale}, _session, socket) do
    Gettext.put_locale(locale)
    {:ok, assign(socket, locale: locale, pay_options: pay_options(locale))}
  end

  def handle_event("make-payment", %{"amount" => amount}, socket) do
    {:ok, body} = Yookassa.Request.payment(amount)
    %{"confirmation" => %{"confirmation_url" => confirmation_url}} = body
    transaction = Yookassa.Helpers.transaction_from_yookassa(body)

    Payments.create_transaction(socket.assigns.current_user, transaction)

    {:noreply, redirect(socket, external: confirmation_url)}
  end

  def pay_options(_locale) do
    [
      %{value: "390.00", label: "390 рублей", litcoins: 1, bonus: 0},
      %{value: "1170.00", label: "1170 рублей", litcoins: 3, bonus: 1},
      %{value: "1950.00", label: "1950 рублей", litcoins: 5, bonus: 2},
      %{value: "3510.00", label: "3510 рублей", litcoins: 9, bonus: 3},
      %{value: "4680.00", label: "4680 рублей", litcoins: 12, bonus: 5},
      %{value: "5850.00", label: "5850 рублей", litcoins: 15, bonus: 10}
    ]
  end
end
