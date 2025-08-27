defmodule ViewOffice.Accounts.Services.CreateMember do
  alias ViewOffice.Repo
  alias ViewOffice.Accounts.{Member, User}

  alias ViewOffice.Scopes.User, as: UserScope
  alias ViewOffice.Scopes.Member, as: MemberScope

  @spec call(map(), UserScope.t() | MemberScope.t()) ::
          {:ok, Member.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, :unauthorized}
  def call(attrs, %UserScope{user: %User{role: "ADMIN"}}) do
    create_member(attrs)
  end

  def call(attrs, %MemberScope{member: %Member{role: role, project_id: project_id}})
      when role in ["Tech Manager", "PM", "Tech Lead"] do
    case Map.get(attrs, :project_id) || Map.get(attrs, "project_id") do
      ^project_id ->
        create_member(attrs)

      _ ->
        {:error, :unauthorized}
    end
  end

  def call(_, _), do: {:error, :unauthorized}

  defp create_member(attrs) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
  end
end
