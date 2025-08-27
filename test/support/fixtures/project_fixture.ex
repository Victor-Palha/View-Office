defmodule ViewOffice.ProjectFixtures do
  import ViewOffice.UserFixtures
  alias ViewOffice.Scopes.User, as: UserScope

  def project_fixture(attrs \\ %{}) do
    user = user_fixture(%{
      role: "ADMIN"
    })

    {:ok, project} =
      attrs
      |> Enum.into(%{
        name: "Test Project",
        description: "A sample project for testing"
      })
      |> ViewOffice.Projects.Services.Create.call(UserScope.for_user(user))

    project
  end
end
