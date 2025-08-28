defmodule ViewOffice.Auth.Authenticator do
  @moduledoc """
  Service to authenticate a user using email and password.
  """

  alias ViewOffice.Repo
  alias ViewOffice.Accounts.User

  @doc """
  Authenticates a user using email and password.

  ## Parameters
  - `email`: The email of the user.
  - `password`: The password of the user.

  ## Returns
  - `{:ok, user}` if credentials are valid.
  - `{:error, :invalid_credentials}` otherwise.
  """
  @spec call(%{email: String.t(), password: String.t()}) ::
          {:ok, any()} | {:error, :invalid_credentials}
  def call(%{email: email, password: password}) do
    email = String.downcase(email)

    case Repo.get_by(User, email: email) do
      nil ->
        {:error, :invalid_credentials}

      %User{} = user ->
        case Argon2.verify_pass(password, user.password_hash) do
          true -> {:ok, user}
          false -> {:error, :invalid_credentials}
        end
    end
  end
end
