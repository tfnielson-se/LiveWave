defmodule LivewaveWeb.Router do
  use LivewaveWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LivewaveWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug LivewaveWeb.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug LivewaveWeb.Plugs.RequireAuth
  end

  scope "/", LivewaveWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/", LivewaveWeb do
    pipe_through [:browser, :authenticated]

    live "/profile", UserLive.UserProfile
    live "/users", UserLive.UserIndex

    live "/new_chat", MessageLive.NewMessage

    live "/chatrooms", ChatroomLive.ChatroomIndex
    live "/chatrooms/:id", ChatroomLive.ChatroomRoom

    # live "/users", UserLive.Index, :index
    # live "/users/new", UserLive.Index, :new
    live "/users/:id/edit", UserLive.Index, :edit
    # live "/users/:id", UserLive.Show, :show
    # live "/users/:id/show/edit", UserLive.Show, :edit

    # live "/chatrooms", ChatroomLive.Index, :index
    # live "/chatrooms/:id/edit", ChatroomLive.Index, :edit
    # live "/chatrooms/new", ChatroomLive.Index, :new
    # live "/chatrooms/:id", ChatroomLive.Show, :show
    # live "/chatrooms/:id/show/edit", ChatroomLive.Show, :edit

    live "/messages", MessageLive.Index, :index
    live "/messages/new", MessageLive.Index, :new
    live "/messages/:id/edit", MessageLive.Index, :edit

    live "/messages/:id", MessageLive.Show, :show
    live "/messages/:id/show/edit", MessageLive.Show, :edit
  end

  scope "/auth", LivewaveWeb do
    pipe_through :browser

    get "/signout", AuthController, :signout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", LivewaveWeb do
  #   pipe_through :api
  # end
end
