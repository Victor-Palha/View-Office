defmodule ViewOffice.Projects.Services.AllTest do
  use ViewOffice.DataCase

  alias ViewOffice.Projects.Services.All
  alias ViewOffice.Scopes.User, as: UserScope

  describe "Fetch all projects" do
    import ViewOffice.UserFixtures
    import ViewOffice.ProjectFixtures
    import ViewOffice.MemberFixture

    test "Should be able to return all projects if user is an admin" do
      user = user_fixture(%{role: "ADMIN", email: "banana@test.com"})
      scope = UserScope.for_user(user)

      project_fixture(%{name: "Project 1"})
      project_fixture(%{name: "Project 2"})

      projects = All.call(scope)
      assert length(projects) == 2
    end

    test "Should return only projects where the user is a member" do
      user = user_fixture(%{role: "COLLABORATOR", email: "user1@test.com"})
      scope = UserScope.for_user(user)

      project1 = project_fixture(%{name: "Project 1"})
      project2 = project_fixture(%{name: "Project 2"})
      project3 = project_fixture(%{name: "Project 3"})

      # o usuário só é membro do projeto1 e projeto2
      member_fixture(%{user_id: user.id, project_id: project1.id})
      member_fixture(%{user_id: user.id, project_id: project2.id})

      projects = All.call(scope)

      assert Enum.map(projects, & &1.id) |> Enum.sort() ==
               Enum.map([project1, project2], & &1.id) |> Enum.sort()

      refute Enum.any?(projects, fn p -> p.id == project3.id end)
    end

    test "Should return empty list if user has no projects" do
      user = user_fixture(%{role: "COLLABORATOR", email: "user2@test.com"})
      scope = UserScope.for_user(user)

      project_fixture(%{name: "Project 1"})
      project_fixture(%{name: "Project 2"})

      projects = All.call(scope)
      assert projects == []
    end
  end
end
