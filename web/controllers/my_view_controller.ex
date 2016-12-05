defmodule QilianPhoenix.MyViewController do
  use QilianPhoenix.Web, :controller

  alias QilianPhoenix.MyView

  def index(conn, _params) do
    my_views = Repo.all(MyView)
    render(conn, "index.html", my_views: my_views)
  end

  def new(conn, _params) do
    changeset = MyView.changeset(%MyView{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"my_view" => my_view_params}) do
    changeset = MyView.changeset(%MyView{}, my_view_params)

    case Repo.insert(changeset) do
      {:ok, _my_view} ->
        conn
        |> put_flash(:info, "My view created successfully.")
        |> redirect(to: my_view_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    my_view = Repo.get!(MyView, id)
    render(conn, "show.html", my_view: my_view)
  end

  def edit(conn, %{"id" => id}) do
    my_view = Repo.get!(MyView, id)
    changeset = MyView.changeset(my_view)
    render(conn, "edit.html", my_view: my_view, changeset: changeset)
  end

  def update(conn, %{"id" => id, "my_view" => my_view_params}) do
    my_view = Repo.get!(MyView, id)
    changeset = MyView.changeset(my_view, my_view_params)

    case Repo.update(changeset) do
      {:ok, my_view} ->
        conn
        |> put_flash(:info, "My view updated successfully.")
        |> redirect(to: my_view_path(conn, :show, my_view))
      {:error, changeset} ->
        render(conn, "edit.html", my_view: my_view, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    my_view = Repo.get!(MyView, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(my_view)

    conn
    |> put_flash(:info, "My view deleted successfully.")
    |> redirect(to: my_view_path(conn, :index))
  end
end
