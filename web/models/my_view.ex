defmodule QilianPhoenix.MyView do
  use QilianPhoenix.Web, :model

  schema "my_views" do
    field :path, :string
    field :content, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:path, :content])
    |> validate_required([:path, :content])
  end
end
