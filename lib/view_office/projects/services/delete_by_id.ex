defmodule ViewOffice.Projects.Services.DeleteById do
  alias ViewOffice.Repo
  alias ViewOffice.Projects.Project
  alias ViewOffice.Accounts.{User, Member}
  alias ViewOffice.Scopes.User, as: UserScope
  alias ViewOffice.Scopes.Member, as: MemberScope

  @spec call(integer(), UserScope.t() | MemberScope.t()) ::
          {:ok, Project.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, :unauthorized}
          | {:error, :not_found}
  def call(project_id, %UserScope{user: %User{role: "ADMIN"}}) do
    delete_project(project_id)
  end

  def call(project_id, %MemberScope{member: %Member{role: role, project_id: project_id}}) when role in ["Tech Manager", "Tech Lead"] do
    delete_project(project_id)
  end

  def call(_, _), do: {:error, :unauthorized}

  defp delete_project(project_id) do
    case Repo.get(Project, project_id) do
      nil ->
        {:error, :not_found}

      project ->
        Repo.delete(project)
    end
  end
end
