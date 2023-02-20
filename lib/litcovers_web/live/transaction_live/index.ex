defmodule LitcoversWeb.TransactionLive.Index do
  use LitcoversWeb, :live_view
  alias Litcovers.Payments
  alias Litcovers.Payments.Yookassa
  # alias Litcovers.Accounts.User

  def mount(%{"locale" => locale}, _session, socket) do
    Gettext.put_locale(locale)
    {:ok, assign(socket, :transactions, Payments.list_transactions())}
  end

  def handle_event("make-payment", %{}, socket) do
    test_shop_id = "986370"
    test_secret_key = "test_LE2NhUWa-qGZv5mNU8dqSDp99dcQ2hfkjj9QAaeBiEY"

    {:ok, body} = Yookassa.Request.payment(test_shop_id, test_secret_key)
    %{"confirmation" => %{"confirmation_url" => confirmation_url}} = body
    transaction = Yookassa.Helpers.transaction_from_yookassa(body)

    Payments.create_transaction(socket.assigns.current_user, transaction)

    {:noreply, redirect(socket, external: confirmation_url)}
  end
end
