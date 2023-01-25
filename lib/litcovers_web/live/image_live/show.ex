defmodule LitcoversWeb.ImageLive.Show do
  use LitcoversWeb, :live_view
  import LitcoversWeb.ImageLive.Index

  alias Litcovers.Media

  @impl true
  def mount(%{"locale" => locale, "id" => id}, _session, socket) do
    image = Media.get_image!(id)
    image_base64 = image.url |> img_url_to_base64()

    author_current_font = fonts_list() |> List.first()
    author_font_base64 = author_current_font |> font_to_base64()

    {:ok,
     assign(socket,
       locale: locale,
       image: image,
       image_base64: image_base64,
       author_current_font: author_current_font,
       author_font_base64: author_font_base64,
       title_font_base64: author_font_base64,
       title_current_font: author_current_font,
       params: initial_params()
     )}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     push_event(socket, "create_cover", %{
       author_font_base64: socket.assigns.author_font_base64,
       title_font_base64: socket.assigns.title_font_base64,
       image_base64: socket.assigns.image_base64,
       params: socket.assigns.params
     })}
  end

  def initial_params do
    %{
      author: "",
      author_position: "TopCenter",
      title: "Harry Potter and other people",
      title_position: "BottomCenter",
      blend_mode: "Overlay",
      alfa: "3.0",
      line_length: "16"
    }
  end

  def title_position_opts do
    ["BottomCenter", "BottomLeft", "BottomStretch", "BottomSides"]
  end

  @impl true
  def handle_event("create-cover", %{"params" => params}, socket) do
    params = update_params(params, socket)
    socket = assign(socket, params: params)

    {:noreply,
     push_event(socket, "create_cover", %{
       author_font_base64: socket.assigns.author_font_base64,
       title_font_base64: socket.assigns.title_font_base64,
       image_base64: socket.assigns.image_base64,
       params: params
     })}
  end

  @impl true
  def handle_event("title-position-change", %{"position" => position}, socket) do
    params = update_params(%{"title_position" => position}, socket)
    socket = assign(socket, params: params)

    {:noreply,
     push_event(socket, "create_cover", %{
       author_font_base64: socket.assigns.author_font_base64,
       title_font_base64: socket.assigns.title_font_base64,
       image_base64: socket.assigns.image_base64,
       params: params
     })}
  end

  @impl true
  def handle_event("next-author-font", _, socket) do
    next_font = socket.assigns.author_current_font |> next_font()
    next_font_base64 = next_font |> font_to_base64()

    socket =
      assign(socket,
        author_current_font: next_font,
        author_font_base64: next_font_base64
      )

    {:noreply,
     push_event(socket, "create_cover", %{
       author_font_base64: socket.assigns.author_font_base64,
       title_font_base64: socket.assigns.title_font_base64,
       image_base64: socket.assigns.image_base64,
       params: socket.assigns.params
     })}
  end

  @impl true
  def handle_event("prev-author-font", _, socket) do
    prev_font = socket.assigns.author_current_font |> prev_font()
    prev_font_base64 = prev_font |> font_to_base64()

    socket =
      assign(socket,
        author_current_font: prev_font,
        author_font_base64: prev_font_base64
      )

    {:noreply,
     push_event(socket, "create_cover", %{
       author_font_base64: socket.assigns.author_font_base64,
       title_font_base64: socket.assigns.title_font_base64,
       image_base64: socket.assigns.image_base64,
       params: socket.assigns.params
     })}
  end

  @impl true
  def handle_event("next-title-font", _, socket) do
    next_font = socket.assigns.title_current_font |> next_font()
    next_font_base64 = next_font |> font_to_base64()

    socket =
      assign(socket,
        title_current_font: next_font,
        title_font_base64: next_font_base64
      )

    {:noreply,
     push_event(socket, "create_cover", %{
       author_font_base64: socket.assigns.author_font_base64,
       title_font_base64: socket.assigns.title_font_base64,
       image_base64: socket.assigns.image_base64,
       params: socket.assigns.params
     })}
  end

  @impl true
  def handle_event("prev-title-font", _, socket) do
    prev_font = socket.assigns.title_current_font |> prev_font()
    prev_font_base64 = prev_font |> font_to_base64()

    socket =
      assign(socket,
        title_current_font: prev_font,
        title_font_base64: prev_font_base64
      )

    {:noreply,
     push_event(socket, "create_cover", %{
       author_font_base64: socket.assigns.author_font_base64,
       title_font_base64: socket.assigns.title_font_base64,
       image_base64: socket.assigns.image_base64,
       params: socket.assigns.params
     })}
  end

  defp update_params(params, socket) do
    params = params |> Enum.into(%{}) |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
    Map.merge(socket.assigns.params, params)
  end

  defp fonts_base_path do
    if System.get_env("MIX_ENV") == "prod" do
      [Application.app_dir(:litcovers), "priv/static/fonts"] |> Path.join()
    else
      "priv/static/fonts"
    end
  end

  defp fonts_list() do
    File.ls!(fonts_base_path())
  end

  def font_to_base64(font_name) do
    [fonts_base_path(), font_name]
    |> Path.join()
    |> File.read!()
    |> Base.encode64()
  end

  def img_url_to_base64(url) do
    res = HTTPoison.get!(url)
    res.body |> Base.encode64()
  end

  def next_font(current_font) do
    current_font_index = fonts_list() |> Enum.find_index(fn font -> font == current_font end)
    next_font_index = current_font_index + 1
    fonts_list() |> Enum.at(next_font_index)
  end

  def prev_font(current_font) do
    current_font_index = fonts_list() |> Enum.find_index(fn font -> font == current_font end)
    prev_font_index = current_font_index - 1
    fonts_list() |> Enum.at(prev_font_index)
  end
end
