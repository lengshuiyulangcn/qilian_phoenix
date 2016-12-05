defmodule QilianPhoenix.MyViewControllerTest do
  use QilianPhoenix.ConnCase

  alias QilianPhoenix.MyView
  @valid_attrs %{content: "some content", path: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, my_view_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing my views"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, my_view_path(conn, :new)
    assert html_response(conn, 200) =~ "New my view"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, my_view_path(conn, :create), my_view: @valid_attrs
    assert redirected_to(conn) == my_view_path(conn, :index)
    assert Repo.get_by(MyView, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, my_view_path(conn, :create), my_view: @invalid_attrs
    assert html_response(conn, 200) =~ "New my view"
  end

  test "shows chosen resource", %{conn: conn} do
    my_view = Repo.insert! %MyView{}
    conn = get conn, my_view_path(conn, :show, my_view)
    assert html_response(conn, 200) =~ "Show my view"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, my_view_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    my_view = Repo.insert! %MyView{}
    conn = get conn, my_view_path(conn, :edit, my_view)
    assert html_response(conn, 200) =~ "Edit my view"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    my_view = Repo.insert! %MyView{}
    conn = put conn, my_view_path(conn, :update, my_view), my_view: @valid_attrs
    assert redirected_to(conn) == my_view_path(conn, :show, my_view)
    assert Repo.get_by(MyView, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    my_view = Repo.insert! %MyView{}
    conn = put conn, my_view_path(conn, :update, my_view), my_view: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit my view"
  end

  test "deletes chosen resource", %{conn: conn} do
    my_view = Repo.insert! %MyView{}
    conn = delete conn, my_view_path(conn, :delete, my_view)
    assert redirected_to(conn) == my_view_path(conn, :index)
    refute Repo.get(MyView, my_view.id)
  end
end
