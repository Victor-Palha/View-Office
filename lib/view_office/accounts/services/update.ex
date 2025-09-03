defmodule ViewOffice.Accounts.Services.Update do
  alias ViewOffice.Repo
  alias ViewOffice.Accounts.User
  alias ViewOffice.Scopes.User, as: UserScope

  def call(%User{} = user, attrs, %UserScope{user: %User{role: "ADMIN"}} = _scope) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end
end
