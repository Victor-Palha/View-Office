defmodule ViewOffice.Projects.Services.DeleteByIdTest do
  use ViewOffice.DataCase
  alias ViewOffice.Repo
  alias ViewOffice.Projects.Services.DeleteById
  alias ViewOffice.Scopes.User, as: UserScope
  alias ViewOffice.Scopes.Member, as: MemberScope
  alias ViewOffice.Projects.Project


  describe "Delete project by id" do
    import ViewOffice.UserFixtures
    import ViewOffice.ProjectFixtures
    import ViewOffice.MemberFixture

    test "Admin should be able to delete any project" do
      user = user_fixture(%{role: "ADMIN", email: "admin@test.com"})
      scope = UserScope.for_user(user)

      project = project_fixture(%{name: "Project X"})
      assert {:ok, %Project{}} = DeleteById.call(project.id, scope)

      refute Repo.get(Project, project.id)
    end

    test "Tech Manager should be able to delete project if belongs to the same project" do
      user = user_fixture(%{role: "COLLABORATOR", email: "manager@test.com"})
      project = project_fixture(%{name: "Managed Project"})

      member = member_fixture(%{user_id: user.id, role: "Tech Manager", project_id: project.id})
      scope = MemberScope.for_member(member)

      assert {:ok, %Project{}} = DeleteById.call(project.id, scope)
      refute Repo.get(Project, project.id)
    end

    test "Tech Lead should NOT be able to delete project if project_id does not match" do
      user = user_fixture(%{role: "COLLABORATOR", email: "lead@test.com"})
      project1 = project_fixture(%{name: "Project 1"})
      project2 = project_fixture(%{name: "Project 2"})

      member = member_fixture(%{user_id: user.id, role: "Tech Lead", project_id: project1.id})
      scope = MemberScope.for_member(member)

      assert {:error, :unauthorized} = DeleteById.call(project2.id, scope)
      assert Repo.get(Project, project2.id)
    end

    test "Should return error not_found if project does not exist" do
      user = user_fixture(%{role: "ADMIN", email: "admin2@test.com"})
      scope = UserScope.for_user(user)

      assert {:error, :not_found} = DeleteById.call(-1, scope)
    end

    test "Regular user cannot delete a project" do
      user = user_fixture(%{role: "COLLABORATOR", email: "normal@test.com"})
      project = project_fixture(%{name: "Protected Project"})

      scope = UserScope.for_user(user)

      assert {:error, :unauthorized} = DeleteById.call(project.id, scope)
      assert Repo.get(Project, project.id)
    end
  end
end
