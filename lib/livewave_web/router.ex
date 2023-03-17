defmodule LivewaveWeb.Router do
  use LivewaveWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LivewaveWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # plug Ueberauth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LivewaveWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/users", UserLive.Index, :index
    live "/users/new", UserLive.Index, :new
    live "/users/:id/edit", UserLive.Index, :edit

    live "/users/:id", UserLive.Show, :show
    live "/users/:id/show/edit", UserLive.Show, :edit
  end

  scope "/auth", LivewaveWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    get "/logout", AuthController, :signout
  end

  # Other scopes may use custom stacks.
  # scope "/api", LivewaveWeb do
  #   pipe_through :api
  # end
end
