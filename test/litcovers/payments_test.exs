defmodule Litcovers.PaymentsTest do
  use Litcovers.DataCase

  alias Litcovers.Payments

  describe "transactions" do
    alias Litcovers.Payments.Transaction

    import Litcovers.PaymentsFixtures

    @invalid_attrs %{amount: nil, currency: nil, description: nil, payment_service: nil}

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Payments.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Payments.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{amount: 42, currency: "some currency", description: "some description", payment_service: "some payment_service"}

      assert {:ok, %Transaction{} = transaction} = Payments.create_transaction(valid_attrs)
      assert transaction.amount == 42
      assert transaction.currency == "some currency"
      assert transaction.description == "some description"
      assert transaction.payment_service == "some payment_service"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      update_attrs = %{amount: 43, currency: "some updated currency", description: "some updated description", payment_service: "some updated payment_service"}

      assert {:ok, %Transaction{} = transaction} = Payments.update_transaction(transaction, update_attrs)
      assert transaction.amount == 43
      assert transaction.currency == "some updated currency"
      assert transaction.description == "some updated description"
      assert transaction.payment_service == "some updated payment_service"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_transaction(transaction, @invalid_attrs)
      assert transaction == Payments.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Payments.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Payments.change_transaction(transaction)
    end
  end
end
