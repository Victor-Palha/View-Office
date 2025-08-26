defmodule ViewOffice.Accounts.Services.All do
  alias ViewOffice.Repo
  alias ViewOffice.Accounts.User
  alias ViewOffice.Scopes.User, as: UserScope

  @spec call(%UserScope{}) :: [User.t() | term()]
  def call(%UserScope{} = _scope) do
    User
    |> Repo.all()
  end
end
