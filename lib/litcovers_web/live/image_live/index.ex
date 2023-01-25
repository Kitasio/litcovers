defmodule LitcoversWeb.ImageLive.Index do
  use LitcoversWeb, :live_view

  alias Litcovers.Media
  alias Litcovers.Media.Image

  @impl true
  def mount(%{"locale" => locale}, _session, socket) do
    {:ok, assign(socket, images: list_images(socket.assigns.current_user), locale: locale)}
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

    {:noreply, assign(socket, :images, list_images(socket.assigns.current_user))}
  end

  def handle_event("toggle-favorite", %{"image_id" => image_id}, socket) do
    image = Media.get_image!(image_id)

    case Media.update_image(image, %{favorite: !image.favorite}) do
      {:ok, _image} ->
        {:noreply, assign(socket, :images, list_images(socket.assigns.current_user))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp list_images(user) do
    Media.list_user_images(user)
  end

  def aspect_ratio({512, 512}), do: "square"
  def aspect_ratio({512, 768}), do: "cover"

  def placeholder_or_empty(nil),
    do: %{
      author: "Герман Мелвилл",
      title: "Моби Дик",
      description:
        "История о мести человека гигантскому белому киту. После того, как кит нападает и убивает его друга, мужчина, Ахав, посвящает свою жизнь выслеживанию и убийству этого существа. В романе затрагиваются темы борьбы добра со злом, Бога и человеческой способности к дикости.",
      vibe: "приключения, опасность, одержимость"
    }

  def placeholder_or_empty(placeholder), do: placeholder
end
