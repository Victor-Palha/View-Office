defmodule ViewOfficeWeb.Router do
  use ViewOfficeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ViewOfficeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ViewOfficeWeb.Plugs.FetchCurrentCollaborator
  end

  pipeline :ensure_authenticated do
    plug ViewOfficeWeb.Plugs.EnsureAuthSession
  end

  pipeline :redirect_if_authenticated do
    plug ViewOfficeWeb.Plugs.RedirectIfAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

    # Public routes
  scope "/", ViewOfficeWeb do
    pipe_through [:browser]

    post "/auth/login", AuthController, :login

    scope "/" do
      pipe_through [:redirect_if_authenticated]

      live "/", LandingLive.Index
      live "/login", LoginLive.Index
    end
  end

  scope "/", ViewOfficeWeb do
    pipe_through :browser

    post "/auth/logout", AuthController, :logout

    live_session :default_auth,
      on_mount: [{ViewOfficeWeb.Plugs.EnsureAuthLiveSession, :ensure_authenticated}] do
      live "/dashboard", DashboardLive.Index
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ViewOfficeWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:view_office, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ViewOfficeWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
