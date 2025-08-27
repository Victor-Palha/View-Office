defmodule ViewOffice.MemberFixture do
  alias ViewOffice.Scopes.User, as: UserScope
  import ViewOffice.UserFixtures
  import ViewOffice.ProjectFixtures

  def member_fixture(attrs \\ %{}) do
    user = user_fixture(%{role: "ADMIN"})
    project = project_fixture()

    {:ok, member} =
      attrs
      |> Enum.into(%{
        name: "Test Member",
        email: "test@example.com",
        role: "Tech Lead",
        user_id: user.id,
        project_id: project.id
      })
      |> ViewOffice.Accounts.Services.CreateMember.call(UserScope.for_user(user))

    member
  end
end
