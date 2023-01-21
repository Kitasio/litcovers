defmodule LitcoversWeb.ImageLive.Index do
  use LitcoversWeb, :live_view

  alias Litcovers.Media
  alias Litcovers.Media.Image

  @impl true
  def mount(%{"locale" => locale}, _session, socket) do
    Gettext.put_locale(locale)
    {:ok, assign(socket, images: list_images(), locale: locale)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Image")
    |> assign(:image, Media.get_image!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Image")
    |> assign(:image, %Image{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Images")
    |> assign(:image, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    image = Media.get_image!(id)
    {:ok, _} = Media.delete_image(image)

    {:noreply, assign(socket, :images, list_images())}
  end

  defp list_images do
    Media.list_images()
  end
end
