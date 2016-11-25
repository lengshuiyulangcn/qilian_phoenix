defmodule QilianPhoenix.User do
  use QilianPhoenix.Web, :model
  import Comeonin.Bcrypt
  alias Ueberauth.Auth
  alias QilianPhoenix.Repo

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :videos, QilianPhoenix.Video

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def new_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
  end
  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
    |> put_change(:password_hash, hashed_password(params["password"]))
  end



  defp hashed_password(password), do: hashpwsalt(password)

end
