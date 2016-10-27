defmodule QilianPhoenix.UsersController do
  use QilianPhoenix.Web, :controller
  alias QilianPhoenix.User
  alias QilianPhoenix.Repo

  def new(conn, _params) do
    changeset = User.new_changeset(%User{})
    render conn, changeset: changeset
  end
  def create(conn, %{"user" => user_params}) do
    changeset = User.create_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
       {:ok, _user} ->
        conn
        |> put_flash(:info, "Your account was created")
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Unable to create account")
        |> render("new.html", changeset: changeset)
    end
  end
end
