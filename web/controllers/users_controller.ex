defmodule QilianPhoenix.UsersController do
  use QilianPhoenix.Web, :controller
  alias QilianPhoenix.User
  alias QilianPhoenix.Repo
  alias QilianPhoenix.Session

  def new(conn, _params) do
    if conn.assigns.current_user do
      conn
      |> put_flash(:info, "Your already logged in")
      |> redirect(to: "/")
    else
      changeset = User.new_changeset(%User{})
      render conn, changeset: changeset
    end
  end
  def edit(conn, _params) do
    unless conn.assigns.current_user do
      conn
      |> put_flash(:info, "You need login")
      |> redirect(to: "/")
    else
      changeset = User.new_changeset(%User{})
      render conn, changeset: changeset
    end
  end
  def create(conn, %{"user" => user_params}) do
    changeset = User.create_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
       {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Your account was created")
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Unable to create account")
        |> render("new.html", changeset: changeset)
    end
  end
  def upload_avatar(conn, %{"user" => user_params}) do
    changeset = User.upload_avatar_changeset(conn.assigns.current_user, user_params)
    case Repo.update(changeset) do
       {:ok, user} ->
        conn
        |> put_flash(:info, "Your avatar was created")
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Unable to create avatar")
        |> render("/", changeset: changeset)
    end
  end
end
