defmodule QilianPhoenix.Router do
  use QilianPhoenix.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser_auth do  
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug QilianPhoenix.Auth
  end

  scope "/", QilianPhoenix do
    pipe_through [:browser, :browser_auth] # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UsersController, only: [:new, :create, :edit]
    post   "/users/upload_avatar",  UsersController, :upload_avatar
    resources "/videos", VideoController
    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    delete "/logout", SessionController, :delete
    scope "/auth" do
      pipe_through :browser

      get "/:provider", SessionController, :request
      get "/:provider/callback", SessionController, :callback
    end
    resources "/my_views", MyViewController
  end

  # Other scopes may use custom stacks.
  # scope "/api", QilianPhoenix do
  #   pipe_through :api
  # end
end
