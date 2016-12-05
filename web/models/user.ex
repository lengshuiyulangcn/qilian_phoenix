defmodule QilianPhoenix.User do
  use QilianPhoenix.Web, :model
  import Comeonin.Bcrypt
  alias Ueberauth.Auth
  alias QilianPhoenix.Repo
  use Arc.Ecto.Schema

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :avatar, QilianPhoenix.Avatar.Type
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

  def upload_avatar_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email])
    |> cast_attachments(params, [:avatar])
    |> validate_required([:email, :avatar])
  end


  defp hashed_password(password), do: hashpwsalt(password)

end
