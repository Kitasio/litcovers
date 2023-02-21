defmodule Litcovers.Payments.TransactionChecker do
  alias Litcovers.Payments.Yookassa
  alias Litcovers.Payments
  alias Litcovers.Accounts
  require Logger
  use Task, restart: :transient

  def start_link(_arg) do
    Task.start_link(&loop/0)
  end

  def loop do
    Logger.info("TransactionChecker working")

    test_shop_id = "986370"
    test_secret_key = "test_LE2NhUWa-qGZv5mNU8dqSDp99dcQ2hfkjj9QAaeBiEY"

    for transaction <- pending_transactions() do
      Logger.info("TransactionChecker: #{inspect(transaction)}")
      {:ok, body} = Yookassa.Request.get_payment_status(transaction.tnx_id, test_shop_id, test_secret_key)
      %{"status" => status} = body

      case status do
        "succeeded" ->
          Logger.info("Transaction #{transaction.id} succeeded")
{:ok, _tnx} = Payments.update_transaction(transaction, %{status: status})
          # TODO
          # calculate litcoins based on transaction amount
          litcoins = 1
          # add litcoins to user
          user = Accounts.get_user!(transaction.user_id)
          {:ok, value} = Accounts.add_litcoins(user, litcoins)
          Logger.info("User #{user.id} now has #{value} litcoins")
        "canceled" ->
          Logger.info("Transaction #{transaction.id} canceled")
          Payments.update_transaction(transaction, %{status: status})
        "waiting_for_capture" ->
          Logger.info("Transaction #{transaction.id} waiting_for_capture")
          Payments.update_transaction(transaction, %{status: status})
        "pending" ->
          Logger.info("Transaction #{transaction.id} is still pending")
        unknown ->
          Logger.warn("Transaction #{transaction.id} has #{unknown} status")
      end
    end

    :timer.minutes(1) |> Process.sleep()
    loop()
  end

  defp pending_transactions do
    Payments.list_pending_transactions()
  end
end
