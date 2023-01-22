defmodule LitcoversWeb.ImageLive.Show do
  use LitcoversWeb, :live_view

  alias Litcovers.Media

  @impl true
  def mount(%{"locale" => locale}, _session, socket) do
    {:ok, assign(socket, locale: locale)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:image, Media.get_image!(id))}
  end

  defp page_title(:show), do: "Show Image"
  defp page_title(:edit), do: "Edit Image"
end
