defmodule QilianPhoenix.UsersController do
  use QilianPhoenix.Web, :controller
  alias QilianPhoenix.User
  alias QilianPhoenix.Repo
  alias QilianPhoenix.Session

  def new(conn, _params) do
    if Session.logged_in?(conn) do
      conn
      |> put_flash(:info, "Your already logged in")
      |> redirect(to: "/")
    else
      changeset = User.new_changeset(%User{})
      render conn, changeset: changeset
    end
  end
  def create(conn, %{"user" => user_params}) do
    changeset = User.create_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
       {:ok, _user} ->
        conn
        |> put_session(:current_user, changeset.id)
        |> put_flash(:info, "Your account was created")
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Unable to create account")
        |> render("new.html", changeset: changeset)
    end
  end
end
