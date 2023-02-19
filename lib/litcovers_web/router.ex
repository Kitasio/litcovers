defmodule LitcoversWeb.Router do
  use LitcoversWeb, :router

  import LitcoversWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LitcoversWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug LitcoversWeb.Plugs.GetReferer

    plug SetLocale,
      gettext: LitcoversWeb.Gettext,
      default_locale: "ru"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LitcoversWeb do
    pipe_through :browser

    get "/", PageController, :dummy
  end

  scope "/:locale", LitcoversWeb do
    pipe_through :browser

    live "/", PageLive.Index, :index

    live "/prompts", PromptLive.Index, :index
    live "/prompts/new", PromptLive.Index, :new
    live "/prompts/:id/edit", PromptLive.Index, :edit

    live "/prompts/:id", PromptLive.Show, :show
    live "/prompts/:id/show/edit", PromptLive.Show, :edit

    live "/placeholders", PlaceholderLive.Index, :index
    live "/placeholders/new", PlaceholderLive.Index, :new
    live "/placeholders/:id/edit", PlaceholderLive.Index, :edit

    live "/placeholders/:id", PlaceholderLive.Show, :show
    live "/placeholders/:id/show/edit", PlaceholderLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", LitcoversWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:litcovers, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LitcoversWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/:locale", LitcoversWeb do
    pipe_through [:browser, :require_authenticated_admin]

    live_session :is_admin, on_mount: [{LitcoversWeb.UserAuth, :is_admin}] do
      live "/admin", AdminLive.Index, :index
      live "/admin/images/:id", AdminLive.Image
    end
  end

  scope "/:locale", LitcoversWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{LitcoversWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/:locale", LitcoversWeb do
    pipe_through [:browser, :require_authenticated_user, :enabled_user]

    live_session :enabled_user,
      on_mount: [{LitcoversWeb.UserAuth, :enabled_user}] do
      live "/images/new", ImageLive.New
    end
  end

  scope "/:locale", LitcoversWeb do
    pipe_through [:browser, :require_authenticated_user, :enabled_user]

    live_session :unlocked_image,
      on_mount: [{LitcoversWeb.UserAuth, :unlocked_image}] do
      live "/images/:id/edit", ImageLive.Show, :show
    end
  end

  scope "/:locale", LitcoversWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{LitcoversWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/images", ImageLive.Index, :index
      live "/images/unlocked", ImageLive.Index, :unlocked
      live "/images/favorites", ImageLive.Index, :favorites
      live "/images/all", ImageLive.Index, :all
    end
  end

  scope "/:locale", LitcoversWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{LitcoversWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
