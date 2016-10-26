defmodule QilianPhoenix.PageController do
  use QilianPhoenix.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
