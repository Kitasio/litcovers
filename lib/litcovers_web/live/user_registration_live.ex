defmodule LitcoversWeb.UserRegistrationLive do
  use LitcoversWeb, :live_view

  alias Litcovers.Accounts
  alias Litcovers.Accounts.User

  def mount(%{"locale" => locale}, _session, socket) do
    Gettext.put_locale(locale)
    changeset = Accounts.change_user_registration(%User{})
    socket = assign(socket, changeset: changeset, trigger_submit: false, locale: locale)
    {:ok, socket, temporary_assigns: [changeset: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/#{socket.assigns.locale}/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, assign(socket, trigger_submit: true, changeset: changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign(socket, changeset: Map.put(changeset, :action, :validate))}
  end

  def render(assigns) do
    ~H"""
    <.navbar locale={@locale} request_path={"/#{@locale}/users/register"} />
    <div class="p-10 sm:my-5 lg:my-20 mx-auto max-w-md rounded-lg sm:border-2 border-stroke-main">
      <.header class="text-center">
        <%= gettext("Register for an account") %>
        <:subtitle>
          <%= gettext("Already registered?") %>
          <.link
            navigate={~p"/#{@locale}/users/log_in"}
            class="font-semibold text-accent-main hover:underline"
          >
            <%= gettext("Sign in") %>
          </.link>
          <%= gettext("to your account now.") %>
        </:subtitle>
      </.header>

      <.simple_form
        :let={f}
        id="registration_form"
        for={@changeset}
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/#{@locale}/users/log_in?_action=registered"}
        method="post"
        as={:user}
      >
        <.error :if={@changeset.action == :insert}>
          <%= gettext("Oops, something went wrong! Please check the errors below.") %>
        </.error>

        <.input field={{f, :email}} type="email" label={gettext("Email")} required />
        <.input field={{f, :password}} type="password" label={gettext("Password")} required />

        <:actions>
          <.button phx-disable-with={gettext("Creating account...")} class="w-full">
            <%= gettext("Create an account") %>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
