defmodule ViewOffice.Accounts.Services.GetById do
  alias ViewOffice.Accounts.User
  alias ViewOffice.Repo
  alias ViewOffice.Scopes.User, as: UserScope

  def call(id, %UserScope{} = _scope) do
    User
    |> Repo.get(id)
    |> case do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end
