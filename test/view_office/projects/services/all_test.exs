defmodule ViewOffice.Projects.Services.AllTest do
  use ViewOffice.DataCase
  alias ViewOffice.Projects.Services.All
  alias ViewOffice.Scopes.User, as: UserScope

  describe "Fetch all projects" do
    import ViewOffice.UserFixtures
    import ViewOffice.ProjectFixtures

    test "Should be able to return all projects if user are an admin" do
      user = user_fixture(%{role: "ADMIN", email: "banana@test.com"})
      scope = UserScope.for_admin(user)
      project_fixture(%{name: "Project 1"})
      projects = All.call(scope)
      assert length(projects) == 1
    end

    test "Should not be able to return all projects if user is not an admin" do
      user = user_fixture(%{role: "COLLABORATOR", email: "banana@test.com"})
      scope = UserScope.for_user(user)
      project_fixture(%{name: "Project 1"})
      assert {:error, :unauthorized} = All.call(scope)
    end
  end
end
