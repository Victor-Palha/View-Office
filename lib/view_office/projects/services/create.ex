defmodule ViewOffice.Projects.Services.Create do
  alias ViewOffice.Projects.Project
  alias ViewOffice.Repo
  alias ViewOffice.Scopes.User, as: UserScope

  @spec call(map(), UserScope.t() | nil) :: {:ok, Project.t()} | {:error, Ecto.Changeset.t() | :unauthorized}
  def call(attrs, %UserScope{user: %{role: "ADMIN"}} = _scope) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  def call(_attrs, nil) do
    {:error, :unauthorized}
  end
end
