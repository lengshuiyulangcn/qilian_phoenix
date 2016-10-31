defmodule QilianPhoenix.SessionController do
  use QilianPhoenix.Web, :controller
  alias QilianPhoenix.Session

  def new(conn, _params) do
    if Session.logged_in?(conn) do
      conn
      |> put_flash(:info, "Your already logged in")
      |> redirect(to: "/")
    else
      render conn, "new.html"
    end
  end

  def create(conn, %{"session" => session_params}) do
  case Session.login(session_params, QilianPhoenix.Repo) do
    {:ok, user} ->
      conn
      |> put_session(:current_user, user.id)
      |> put_flash(:info, "Logged in")
      |> redirect(to: "/")
    :error ->
      conn
      |> put_flash(:info, "Wrong email or password")
      |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end
end
