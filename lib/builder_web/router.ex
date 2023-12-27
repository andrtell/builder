defmodule BuilderWeb.Router do
  use BuilderWeb, :router

  import BuilderWeb.Plugs.Auth
  import BuilderWeb.Plugs.Debug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BuilderWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :auth_fetch_user
    plug :debug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BuilderWeb do
    pipe_through :browser

    get "/", PageController, :home

  end

  scope "/", BuilderWeb do
    pipe_through [:browser]

    delete "/users/logout", UserSessionController, :delete
  end

  scope "/", BuilderWeb do
    pipe_through [:browser, :auth_redirect_if_admin]

    live_session :anon,
      on_mount: [{BuilderWeb.OnMount, :redirect_if_admin}] do
      live "/login", LoginLive, :new
    end

    post "/users/login", UserSessionController, :create
  end

  scope "/", BuilderWeb do
    pipe_through [:browser, :auth_redirect_if_anon]

    live_session :admin,
      on_mount: [{BuilderWeb.OnMount, :redirect_if_anon}] do
      live "/admin", AdminLive, :new
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", BuilderWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:builder, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BuilderWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
