defmodule QilianPhoenix.MyViewTest do
  use QilianPhoenix.ModelCase

  alias QilianPhoenix.MyView

  @valid_attrs %{content: "some content", path: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = MyView.changeset(%MyView{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = MyView.changeset(%MyView{}, @invalid_attrs)
    refute changeset.valid?
  end
end
