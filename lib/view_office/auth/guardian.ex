defmodule ViewOffice.Auth.Guardian do
  use Guardian, otp_app: :view_office

  @moduledoc """
  Authentication module for generating and verifying tokens.
  Responsible for generating and verifying tokens for authentication using Guardian.

  Provides functions to:
  - Authenticate users
  - Generate tokens with different expiration times
  - Verify tokens and validate type and role
  """

  # 1 hour
  @main_token_ttl 60 * 60
  # 10 day
  @refresh_token_ttl 60 * 60 * 24 * 10
  # 5 minutes
  @temporary_token_ttl 60 * 5

  @doc """
  Generates a token of the given type with the appropriate expiration time and role.
  """
  @spec generate_token(any(), atom(), String.t()) ::
          {:ok, Guardian.Token.token(), Guardian.Token.claims()} | {:error, any()}
  def generate_token(entity, type, role)
      when type in [:main_token, :refresh_token, :temporary_token] do
    {token_type, ttl} =
      case type do
        :main_token -> {"main", @main_token_ttl}
        :refresh_token -> {"refresh", @refresh_token_ttl}
        :temporary_token -> {"temporary", @temporary_token_ttl}
      end

    exp = Guardian.timestamp() + ttl

    claims = %{
      "typ" => token_type,
      "exp" => exp,
      "role" => role
    }

    encode_and_sign(entity, claims, token_type: token_type)
  end

  @doc """
  Verifies a token and returns the claims if valid.
  """
  def verify_token(token) do
    case decode_and_verify(token) do
      {:ok, claims} -> {:ok, claims}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Verifies the token type.
  Returns claims if the token is valid and the type matches.
  """
  @spec verify_token_type(Guardian.Token.token(), String.t()) :: {:ok, map()} | {:error, any()}
  def verify_token_type(token, expected_type) do
    with {:ok, claims} <- verify_token(token),
         true <- claims["typ"] == expected_type do
      {:ok, claims}
    else
      false -> {:error, "Invalid token type"}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Returns the subject for the token (used internally by Guardian).
  """
  def subject_for_token(%{id: id}, _claims) do
    {:ok, to_string(id)}
  end

  @doc """
  Retrieves the resource from the claims.
  Returns a map with `:id` and `:role`.
  """
  def resource_from_claims(%{"sub" => id, "role" => role}) do
    {:ok, %{id: id, role: role}}
  end
end
