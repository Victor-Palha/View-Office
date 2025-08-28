defmodule ViewOffice.Auth.GenRandomPass do
  @moduledoc """
  Service to generate a random password for a user.
  """

  @doc """
  Generates a random password of the specified length.

  ## Parameters
  - `length`: The length of the password to generate (default is 12).

  ## Returns
  - A string representing the generated password.
  """
  @spec call(integer()) :: String.t()
  def call(length \\ 12) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64(padding: false)
    |> String.slice(0, length)
  end
end
