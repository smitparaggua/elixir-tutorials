defmodule RumblWeb.Router do
  use RumblWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug RumblWeb.CurrentUser, user_finder: &Rumbl.Accounts.get_user/1
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RumblWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/users", UserController, only: [:new, :create]

    scope "/" do
      pipe_through RumblWeb.RequireUser
      resources "/users", UserController, only: [:index, :show]
      resources "/videos", VideoController
    end
  end
end
