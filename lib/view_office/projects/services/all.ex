defmodule ViewOffice.Projects.Services.All do
  alias ViewOffice.Projects.Project
  alias ViewOffice.Repo
  alias ViewOffice.Scopes.User, as: UserScope

  @spec call(UserScope.t() | nil) :: [Project.t()] | [] | {:error, :unauthorized}
  def call(%UserScope{user: %{role: "ADMIN"}} = _scope) do
    Project
    |> Repo.all()
  end

  def call(_scope) do
    {:error, :unauthorized}
  end
end
