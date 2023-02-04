defmodule LitcoversWeb.AdminLive.Index do
  use LitcoversWeb, :live_view
  alias Litcovers.Accounts

  @impl true
  def mount(%{"locale" => locale}, _session, socket) do
    users = Accounts.list_regular_users()

    drip_machine =
      case GenServer.whereis(Litcovers.DrippingMachine) do
        nil -> false
        _ -> true
      end

    {:ok, assign(socket, locale: locale, users: users, drip_machine: drip_machine)}
  end

  @impl true
  def handle_event("add-litcoin", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    Accounts.add_litcoins(user, 1)
    {:noreply, assign(socket, users: Accounts.list_regular_users())}
  end

  @impl true
  def handle_event("remove-litcoin", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    Accounts.remove_litcoins(user, 1)
    {:noreply, assign(socket, users: Accounts.list_regular_users())}
  end

  @impl true
  def handle_event("toggle-enabled", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    Accounts.update_enabled(user, %{enabled: !user.enabled})
    {:noreply, assign(socket, users: Accounts.list_regular_users())}
  end

  @impl true
  def handle_event("toggle-dripping_machine", %{}, socket) do
    if GenServer.whereis(Litcovers.DrippingMachine) != nil do
      Litcovers.DrippingMachine.stop_dripping()
    else
      Litcovers.DrippingMachine.start_link()
    end

    drip_machine =
      case GenServer.whereis(Litcovers.DrippingMachine) do
        nil -> false
        _ -> true
      end

    {:noreply, assign(socket, users: Accounts.list_regular_users(), drip_machine: drip_machine)}
  end
end
