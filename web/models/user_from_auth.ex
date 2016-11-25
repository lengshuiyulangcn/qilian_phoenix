defmodule UserFromAuth do
  @moduledoc """
  Retrieve the user information from an auth request
  """
  alias Ueberauth.Auth
  alias QilianPhoenix.User 
  alias QilianPhoenix.Repo

  def find_or_create(%Auth{provider: :identity} = auth) do
    case validate_pass(auth.credentials) do
      :ok ->
        {:ok, basic_info(auth)}
      {:error, reason} -> {:error, reason}
    end
  end

  def find_or_create(%Auth{} = auth) do
    basic_info(auth)
  end

  defp basic_info(auth) do
    params = %{"name"=> name_from_auth(auth), "email"=> auth.info.email}
    user = Repo.get_by(User, email:  params["email"])
    case user do
      nil -> create_user(params)
       _  -> {:ok, user}
    end
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name = [auth.info.first_name, auth.info.last_name]
      |> Enum.filter(&(&1 != nil and &1 != ""))

      cond do
        length(name) == 0 -> auth.info.nickname
        true -> Enum.join(name, " ")
      end
    end
  end

  defp create_user(params) do
     params = Map.put(params, "password", random_string(16) )
     changeset = User.create_changeset(%User{}, params)
     case Repo.insert(changeset) do
       {:ok, _user} -> {:ok, _user} 
       {:error, changeset} -> {:error, changeset}
     end
  end
  defp validate_pass(%{other: %{password: ""}}) do
    {:error, "Password required"}
  end
  defp validate_pass(%{other: %{password: pw, password_confirmation: pw}}) do
    :ok
  end
  defp validate_pass(%{other: %{password: _}}) do
    {:error, "Passwords do not match"}
  end
  defp validate_pass(_), do: {:error, "Password Required"}

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
