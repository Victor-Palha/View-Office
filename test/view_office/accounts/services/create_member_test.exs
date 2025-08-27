defmodule ViewOffice.Accounts.Services.CreateMemberTest do
  use ViewOffice.DataCase
  alias ViewOffice.Accounts.Services.CreateMember
  alias ViewOffice.Scopes.Member, as: MemberScope
  alias ViewOffice.Scopes.User, as: UserScope

  describe "Create Member" do
    import ViewOffice.UserFixtures
    import ViewOffice.ProjectFixtures

    test "Should be able to create a Member" do
      user = user_fixture(%{
        email: "admin@example.com",
        role: "ADMIN"
      })
      project = project_fixture()

      assert {:ok, member} = CreateMember.call(%{
        user_id: user.id,
        role: "Developer",
        project_id: project.id,
      }, UserScope.for_user(user))

      assert member.user_id == user.id
      assert member.project_id == project.id
    end

    test "Should be able to create a Member when creator are from manager" do
      user = user_fixture(%{
        email: "manager@example.com",
        role: "ADMIN"
      })

      developer = user_fixture(%{
        email: "developer@example.com",
        role: "COLLABORATOR"
      })

      project = project_fixture()

      {:ok, member} = CreateMember.call(%{
        user_id: user.id,
        role: "Tech Lead",
        project_id: project.id,
      }, UserScope.for_user(user))

      assert {:ok, dev_member} = CreateMember.call(%{
        user_id: developer.id,
        role: "Developer",
        project_id: project.id,
      }, MemberScope.for_member(member))

      assert dev_member.user_id == developer.id
      assert dev_member.project_id == project.id
      assert dev_member.role == "Developer"
    end

    test "Should not be able to create a Member with invalid data" do
      user = user_fixture(%{
        email: "admin2@example.com",
        role: "ADMIN"
      })

      project = project_fixture()

      assert {:error, changeset} = CreateMember.call(%{
        user_id: user.id,
        project_id: project.id,
      }, UserScope.for_user(user))

      assert changeset.errors[:role] == {"can't be blank", [validation: :required]}
    end

    test "Should not be able to create a Member from a non ADMIN user" do
      user = user_fixture(%{
        email: "collaborator@example.com",
        role: "COLLABORATOR"
      })

      project = project_fixture()

      assert {:error, :unauthorized} = CreateMember.call(%{
        user_id: user.id,
        project_id: project.id,
        role: "Developer"
      }, UserScope.for_user(user))
    end
  end
end
