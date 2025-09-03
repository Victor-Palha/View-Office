defmodule ViewOffice.Accounts.Services.Create do
  alias ViewOffice.Accounts.User
  alias ViewOffice.Repo
  alias ViewOffice.Scopes.User, as: UserScope

  @spec call(map(), %UserScope{}) :: {:ok, any()} | {:error, Ecto.Changeset.t()}
  def call(attrs, %UserScope{user: %User{role: "ADMIN"}} = _scope) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
