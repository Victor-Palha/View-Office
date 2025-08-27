defmodule ViewOffice.Projects.Services.All do
  import Ecto.Query
  alias ViewOffice.Repo
  alias ViewOffice.Projects.Project
  alias ViewOffice.Accounts.Member
  alias ViewOffice.Scopes.User, as: UserScope
  alias ViewOffice.Scopes.Member, as: MemberScope

  @spec call(UserScope.t() | MemberScope.t() | nil) :: [Project.t()] | [] | {:error, :unauthorized}
  def call(%UserScope{user: %{role: "ADMIN"}} = _scope) do
    Project
    |> Repo.all()
  end

  def call(%UserScope{user: %{id: id}}) do
    project_ids =
      from(m in Member,
        where: m.user_id == ^id,
        select: m.project_id
      )
      |> Repo.all()

    from(p in Project, where: p.id in ^project_ids)
    |> Repo.all()
  end

  def call(_) do
    {:error, :unauthorized}
  end
end
