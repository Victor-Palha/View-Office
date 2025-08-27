defmodule ViewOffice.Accounts.Services.CreateMember do
  alias ViewOffice.Accounts.Member
  alias ViewOffice.Repo
  alias ViewOffice.Accounts.User
  alias ViewOffice.Scopes.User, as: UserScope
  alias ViewOffice.Scopes.Member, as: MemberScope

  @spec call(Member.t(), UserScope.t() | MemberScope.t()) :: {:ok, Member.t()} | {:error, Ecto.Changeset.t()} | {:error, :unauthorized}
  def call(attrs, %UserScope{user: %User{role: "ADMIN"}} = _scope), do: create_member(attrs)

  def call(attrs, %MemberScope{member: %Member{role: role}} = _scope) when role in ["Tech Manager", "PM", "Tech Lead"], do: create_member(attrs)

  def call(_, _), do: {:error, :unauthorized}

  defp create_member(attrs) do
      %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
  end
end
