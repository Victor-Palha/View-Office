defmodule ViewOffice.Accounts.Services.DeleteMemberById do
  alias ViewOffice.Repo
  alias ViewOffice.Scopes.Member, as: MemberScope
  alias ViewOffice.Scopes.User, as: UserScope
  alias ViewOffice.Accounts.{User, Member}

  @spec call(integer(), UserScope.t() | MemberScope.t()) ::
          {:ok, Member.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, :unauthorized}
          | {:error, :not_found}
  def call(id, %UserScope{user: %User{role: "ADMIN"}}) do
    case Repo.get(Member, id) do
      nil -> {:error, :not_found}
      member -> Repo.delete(member)
    end
  end

  def call(id, %MemberScope{member: %Member{role: role, project_id: project_id}})
      when role in ["Tech Manager", "PM", "Tech Lead"] do
    case Repo.get(Member, id) do
      nil ->
        {:error, :not_found}

      member_to_be_deleted ->
        if member_to_be_deleted.project_id == project_id do
          Repo.delete(member_to_be_deleted)
        else
          {:error, :unauthorized}
        end
    end
  end

  def call(_, _), do: {:error, :unauthorized}
end
