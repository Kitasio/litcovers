defmodule LitcoversWeb.UiComponents do
  use Phoenix.Component
  import LitcoversWeb.Gettext
  import LitcoversWeb.CoreComponents
  alias Phoenix.LiveView.JS

  attr :request_path, :string, required: true
  attr :locale, :string, required: true

  def navbar(assigns) do
    ~H"""
    <div class="col-span-12 py-7 px-8 flex justify-between items-center relative">
      <a href="/">
        <svg
          class="w-2/3 sm:w-full"
          width="163"
          height="27"
          viewBox="0 0 163 27"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            d="M9.248 3.6H0.32V4.048C0.32 4.048 1.792 4.08 2.208 4.208C2.976 4.4 3.2 4.848 3.296 5.456C3.392 5.872 3.392 6.64 3.424 7.248V22.352C3.392 22.96 3.392 23.728 3.296 24.144C3.2 24.752 2.976 25.2 2.208 25.392C1.792 25.52 0.32 25.552 0.32 25.552V26H17.984L19.392 12.464H18.944C18.944 12.464 18.272 18.736 17.728 21.616C17.088 25.104 15.648 25.264 13.664 25.392C11.712 25.552 6.24 25.488 6.048 25.488L6.112 4.304L9.248 4.048V3.6ZM21.6733 22.352C21.6733 22.96 21.6733 23.728 21.5773 24.144C21.4813 24.752 21.2253 25.2 20.4893 25.392C20.0733 25.52 18.6013 25.552 18.6013 25.552V26H27.4333V25.552C27.4333 25.552 25.9613 25.52 25.5453 25.392C24.8093 25.2 24.5533 24.752 24.4573 24.144C24.3613 23.728 24.3613 22.64 24.3613 21.808V7.792C24.3613 6.96 24.3613 5.872 24.4573 5.456C24.5533 4.848 24.8093 4.4 25.5453 4.208C25.9613 4.08 27.4333 4.048 27.4333 4.048V3.6H18.6013V4.048C18.6013 4.048 20.0733 4.08 20.4893 4.208C21.2253 4.4 21.4813 4.848 21.5773 5.456C21.6733 5.872 21.6733 6.96 21.6733 7.792V22.352ZM29.222 3.632L29.318 0.848H28.87L28.518 4.016L27.11 15.504L27.558 15.568C27.558 15.568 28.102 12.176 28.326 10.576C28.998 5.776 29.958 4.24 33.35 4.176C34.022 4.176 35.206 4.144 35.206 4.144H36.87V22.512C36.87 23.056 36.806 23.856 36.742 24.24C36.646 24.816 36.454 25.232 35.686 25.456C35.302 25.552 33.894 25.584 33.894 25.584V26H42.47V25.552L39.558 25.328V4.112H41.222C41.222 4.112 42.406 4.144 43.078 4.144C46.47 4.208 47.43 5.744 48.102 10.544C48.326 12.144 48.87 15.536 48.87 15.536L49.318 15.472L47.91 3.984L47.558 0.815998H47.11L47.206 3.6L29.222 3.632ZM64.3675 1.072H63.9195L63.5355 4.784C63.5355 4.784 61.6475 3.056 58.7355 3.056C53.3595 3.056 48.6875 6.896 48.6875 14.736C48.6875 18.48 51.6635 26.352 60.9755 26.352C64.0795 26.352 66.2555 25.136 67.7595 23.376C69.4555 25.104 71.7915 26.256 74.5755 26.256C79.7915 26.256 83.7595 21.52 83.7595 14.768C83.7595 9.264 79.7595 3.344 73.1035 3.344C67.9195 3.344 64.3035 7.792 64.3035 14.768C64.3035 17.616 65.3595 20.656 67.3115 22.896C66.1275 24.08 64.4315 24.848 62.1275 24.848C50.2235 24.848 46.0315 4.656 56.1115 4.656C59.4395 4.656 62.1595 6.352 63.9195 9.52H64.3675V1.072ZM81.9995 18.096C81.9995 21.808 80.2075 24.912 76.1435 24.912C73.2635 24.912 70.9595 23.344 69.2635 21.072C70.1915 19.088 70.5435 16.848 70.5435 14.896C70.5435 13.264 70.2555 10.64 69.4235 8.592L68.9755 8.816C68.9755 8.816 70.0315 11.472 70.0315 14.928C70.0315 16.688 69.7435 18.768 68.9115 20.56C67.0875 17.84 66.0955 14.288 66.0955 11.088C66.0955 7.536 67.6315 4.688 71.4395 4.688C78.2235 4.688 81.9995 12.304 81.9995 18.096ZM94.79 4.048V3.6H84.07V4.048C84.07 4.048 85.862 4.144 86.598 4.304C87.078 4.4 87.75 4.624 88.23 5.2C88.934 6 89.798 8.528 89.798 8.528L89.478 7.632L96.07 26H96.678L102.63 8.592C102.662 8.464 103.366 6.576 103.91 5.584C104.294 4.912 104.646 4.528 105.318 4.336C106.022 4.144 107.718 4.048 107.718 4.048V3.6H98.854V4.048L103.494 4.304L97.414 22.032L90.95 4.336L94.79 4.048ZM114.111 4.112H117.279C117.983 4.112 118.751 4.144 119.423 4.208C122.559 4.432 124.735 6.928 126.367 10.256L127.711 13.072L128.159 12.848L123.743 3.6H108.351V4.048C108.351 4.048 109.823 4.08 110.239 4.208C110.975 4.4 111.231 4.848 111.327 5.456C111.423 5.872 111.423 6.64 111.423 7.248V22.352C111.423 22.96 111.423 23.728 111.327 24.144C111.231 24.752 110.975 25.2 110.239 25.392C109.823 25.52 108.351 25.552 108.351 25.552V26H125.663L127.071 12.464L126.559 12.432C126.559 12.432 125.951 18.736 125.407 21.616C124.767 25.104 123.327 25.264 121.343 25.392C120.671 25.456 119.679 25.488 118.623 25.488H114.111V10.928H115.071C117.151 10.928 118.527 11.408 119.807 13.168C120.639 14.288 124.511 21.232 124.511 21.232L124.895 21.008L117.599 7.472L117.183 7.664L118.367 10.416H114.111V4.112ZM126.57 26H136.458V25.584L132.298 25.264L132.33 23.984V4.112H133.098C137.482 4.112 142.218 6.416 142.218 11.856C142.218 14.032 141.418 16.048 139.914 17.456L135.818 9.968L135.402 10.16L139.05 18.128C137.866 18.896 136.394 19.376 134.634 19.376H133.93V19.888H134.954C136.682 19.888 138.218 19.632 139.53 19.152L142.41 25.424L140.714 25.552V26H147.914V25.552C147.914 25.552 146.058 25.488 145.482 25.264C144.842 25.008 144.394 24.656 143.818 24.016C143.274 23.376 142.186 21.616 142.122 21.52L140.586 18.704C143.402 17.296 144.906 14.736 144.906 11.888C144.906 7.152 141.226 3.6 133.098 3.6H126.57V4.048C126.57 4.048 128.042 4.08 128.458 4.208C129.194 4.4 129.45 4.848 129.546 5.456C129.642 5.872 129.642 6.64 129.642 7.248V21.808C129.642 22.64 129.642 23.728 129.546 24.144C129.45 24.752 129.194 25.2 128.458 25.392C128.042 25.52 126.57 25.552 126.57 25.552V26ZM147.783 6.512C147.783 8.688 149.319 10.128 151.335 11.376L143.111 18.448L143.367 18.8L146.791 16.336C146.343 19.504 147.303 26.448 154.951 26.448C159.111 26.448 162.471 24.08 162.471 19.984C162.471 18.224 162.055 16.816 161.415 15.632L159.015 1.68L158.567 1.744L158.983 5.328C157.639 4.048 154.823 3.12 152.359 3.12C149.895 3.12 147.783 4.048 147.783 6.512ZM152.935 10C150.535 9.04 148.615 8.176 148.615 6.448C148.615 4.688 149.895 3.696 151.623 3.696C154.407 3.696 158.375 6.288 160.103 12.368C160.295 13.008 160.487 13.776 160.647 14.544C158.855 12.336 156.007 11.216 153.543 10.256L156.231 7.76L155.943 7.408L152.935 10ZM151.943 11.76C155.495 13.872 160.007 15.728 160.007 20.368C160.007 23.408 157.831 25.936 154.567 25.936C148.071 25.936 146.855 16.496 150.599 13.008L151.943 11.76Z"
            fill="white"
          />
        </svg>
      </a>

      <.link_button navigate={"/#{@locale}/images/new"}>
        <%= gettext("Create cover") %>
      </.link_button>
    </div>

    <div class="col-span-12 flex border-b-2 border-accent-sec">
      <%= if @request_path == "/#{@locale}/images/new" do %>
        <div class="flex items-center gap-2 px-8 py-4 bg-sec -mb-0.5 rounded-tr-lg border-t-2 border-r-2 border-accent-sec">
          <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="none">
            <path
              stroke="#fff"
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M11.083 1.75H2.917c-.645 0-1.167.522-1.167 1.167v8.166c0 .645.522 1.167 1.167 1.167h8.166c.645 0 1.167-.522 1.167-1.167V2.917c0-.645-.522-1.167-1.167-1.167ZM7 4.667v4.666M4.667 7h4.667"
            />
          </svg>
          <.link navigate={"/#{@locale}/images/new"}>
            <%= gettext("Create") %>
          </.link>
        </div>
      <% else %>
        <div class="flex items-center gap-2 px-8 py-4 bg-main -mb-0.5 border-b-2 border-accent-sec">
          <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="none">
            <path
              stroke="#fff"
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M11.083 1.75H2.917c-.645 0-1.167.522-1.167 1.167v8.166c0 .645.522 1.167 1.167 1.167h8.166c.645 0 1.167-.522 1.167-1.167V2.917c0-.645-.522-1.167-1.167-1.167ZM7 4.667v4.666M4.667 7h4.667"
            />
          </svg>
          <.link navigate={"/#{@locale}/images/new"}>
            <%= gettext("Create") %>
          </.link>
        </div>
      <% end %>

      <%= if @request_path == "/#{@locale}/images" do %>
        <div class="flex items-center gap-2 px-8 py-4 bg-sec -mb-0.5 rounded-tl-lg rounded-tr-lg border-l-2 border-t-2 border-r-2 border-accent-sec">
          <.link navigate={"/#{@locale}/images"}>
            <%= gettext("My generations") %>
          </.link>
        </div>
      <% else %>
        <div class="flex items-center gap-2 px-8 py-4 bg-main -mb-0.5 border-b-2 border-accent-sec">
          <.link navigate={"/#{@locale}/images"}>
            <%= gettext("My generations") %>
          </.link>
        </div>
      <% end %>
    </div>
    """
  end

  attr :img_url, :string, default: nil
  attr :image_id, :string, default: nil
  attr :locale, :string, default: "en"
  attr :id, :string, default: "mainImage"
  attr :aspect_ratio, :string, default: "cover"
  attr :favorite, :boolean, default: false

  def img(assigns) do
    if assigns.img_url do
      ~H"""
      <div
        x-data={"{ showImage: false, showToolbar: false, imageUrl: '#{@img_url}' }"}
        class={"relative group bg-sec max-w-lg overflow-hidden rounded-lg aspect-#{@aspect_ratio} transition-all duration-300 mx-auto"}
        x-on:mouseenter="showToolbar = !showToolbar"
        x-on:mouseleave="showToolbar = !showToolbar"
        id={"img-box-#{@image_id}"}
      >
        <.link href={"/#{@locale}/images/#{@image_id}"}>
          <img
            id={@id}
            x-show="showImage"
            x-transition.duration.300ms
            x-bind:src="imageUrl"
            x-on:load="showImage = true"
            alt="Generated picture"
            class="w-full h-full object-cover aspect-cover"
          />
        </.link>
        <div
          x-show="showToolbar"
          x-transition.duration.200ms
          class="p-5 absolute gap-5 flex justify-center z-20 bottom-0 left-0 w-full"
        >
          <.heart_button favorite={@favorite} image_id={@image_id} />

          <Heroicons.academic_cap class="w-8 h-8" />
          <Heroicons.bars_arrow_up class="w-8 h-8" />
          <Heroicons.magnifying_glass class="w-8 h-8" />
        </div>
      </div>
      """
    else
      ~H"""
      <div class={"relative bg-sec max-w-lg overflow-hidden rounded-lg aspect-#{@aspect_ratio} transition-all duration-300 mx-auto"} />
      """
    end
  end

  attr :image_id, :string, default: nil
  attr :favorite, :boolean, default: false

  def heart_button(assigns) do
    ~H"""
    <button
      id={"heart-#{@image_id}"}
      class="transition duration-150 ease-out"
      phx-value-image_id={@image_id}
      phx-click={
        JS.push("toggle-favorite")
        |> JS.transition("scale-90", to: "#heart-#{@image_id}")
      }
    >
      <div class="bg-sec/50 p-2.5 rounded-full">
        <%= if @favorite do %>
          <Heroicons.heart solid class="fill-accent-main w-6 h-6 transition-all" />
        <% else %>
          <Heroicons.heart class="w-6 h-6 transition-all" />
        <% end %>
      </div>
    </button>
    """
  end

  attr :aspect_ratio, :string, default: "cover"
  attr :class, :string, default: nil

  def loader(assigns) do
    ~H"""
    <div class={[
      "bg-sec flex items-center justify-center max-w-lg overflow-hidden",
      "rounded-lg aspect-#{@aspect_ratio} transition-all duration-300 mx-auto",
      @class
    ]}>
      <svg
        class="animate-slow-spin"
        xmlns="http://www.w3.org/2000/svg"
        width="14"
        height="14"
        fill="none"
      >
        <g clip-path="url(#a)">
          <g stroke="#fff" stroke-linecap="round" stroke-linejoin="round" clip-path="url(#b)">
            <path d="M7 1.167V3.5M7 10.5v2.333M2.876 2.876l1.65 1.65M9.473 9.473l1.651 1.651M1.167 7H3.5M10.5 7h2.333M2.876 11.124l1.65-1.65M9.473 4.527l1.651-1.651" />
          </g>
        </g>
        <defs>
          <clipPath><path fill="#fff" d="M0 0h14v14H0z" /></clipPath>
          <clipPath><path fill="#fff" d="M0 0h14v14H0z" /></clipPath>
        </defs>
      </svg>
    </div>
    """
  end

  attr :value, :string
  attr :for, :string

  def input_overlay(%{for: "author"} = assigns) do
    ~H"""
    <div class="flex flex-col gap-5">
      <div class="flex justify-between items-center">
        <.header><%= gettext("Author's name") %></.header>
        <.type_selector type="author" />
      </div>
      <.input id="author-input" value={@value} type="text" errors={[]} name="params[author]" />
    </div>
    """
  end

  def input_overlay(%{for: "title"} = assigns) do
    ~H"""
    <div class="flex flex-col gap-5">
      <div class="flex justify-between items-center">
        <.header><%= gettext("Title") %></.header>
        <.type_selector type="title" />
      </div>
      <.input id="title-input" value={@value} type="text" errors={[]} name="params[title]" />
    </div>
    """
  end

  attr :type, :string

  def type_selector(assigns) do
    ~H"""
    <div class="px-2.5 flex items-center gap-3 border-2 border-stroke-sec bg-tag-sec rounded-lg">
      <Heroicons.chevron_left
        class="w-5 h-5 cursor-pointer hover:scale-105 transition"
        phx-click={"prev-#{@type}-font"}
      />
      <span>T</span>
      <Heroicons.chevron_right
        class="w-5 h-5 cursor-pointer hover:scale-105 transition"
        phx-click={"next-#{@type}-font"}
      />
    </div>
    """
  end
end
