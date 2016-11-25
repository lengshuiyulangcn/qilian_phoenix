defmodule QilianPhoenix.SessionController do
  use QilianPhoenix.Web, :controller
  alias QilianPhoenix.User
  plug Ueberauth
  alias Ueberauth.Strategy.Helpers
  alias QilianPhoenix.Session 

  def new(conn, _params) do
    if conn.assigns.current_user do
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
      |> Guardian.Plug.sign_in(user)
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
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end
