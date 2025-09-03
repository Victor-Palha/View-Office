defmodule ViewOffice.Accounts.Services.DeleteById do
    @moduledoc """
  Service to retrieve a user by ID and delete it.
  """
  alias ViewOffice.Repo
  alias ViewOffice.Accounts.User
  alias ViewOffice.Scopes.User, as: UserScope

  @doc """
  Deletes a user by ID.
  ## Parameters
  - `id`: The ID of the user to delete.
  ## Returns
  - `{:ok, user}` if the user was found and deleted.
  - `{:error, :not_found}` if the user was not found.
  """
  @spec call(integer(), %UserScope{}) :: {:ok, any()} | {:error, :not_found}
  def call(id, %UserScope{user: %User{role: "ADMIN"}} = _scope) do
    with {:ok, user} <- get_by_id(id) do
      Repo.delete(user)
    else
      {:error, :not_found} -> {:error, :not_found}
    end
  end

  @spec get_by_id(integer()) :: {:ok, any()} | {:error, :not_found}
  defp get_by_id(id) do
    Repo.get(User, id)
    |> case do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end
