defmodule ViewOffice.Accounts.Services.DeleteMemberByIdTest do
  use ViewOffice.DataCase
  alias ViewOffice.Repo

  alias ViewOffice.Accounts.Services.DeleteMemberById
  alias ViewOffice.Accounts.Member
  alias ViewOffice.Scopes.User, as: UserScope
  alias ViewOffice.Scopes.Member, as: MemberScope
  import ViewOffice.MemberFixture

  describe "Delete member by id" do
    import ViewOffice.UserFixtures
    import ViewOffice.MemberFixture
    test "deletes a member if user is admin" do
      user = user_fixture(%{role: "ADMIN"})
      member = member_fixture()

      assert {:ok, %Member{}} = DeleteMemberById.call(member.id, UserScope.for_user(user))
      assert Repo.get(Member, member.id) == nil
    end

    test "deletes a member if user is from management and same project" do
      member = member_fixture()
      user = member_fixture(%{role: "Tech Manager", project_id: member.project_id})

      assert {:ok, %Member{}} = DeleteMemberById.call(member.id, MemberScope.for_member(user))
      assert Repo.get(Member, member.id) == nil
    end

    test "returns error if user is an ADMIN from project and tries to delete another project member" do
      user = member_fixture(%{role: "Tech Manager"})
      member = member_fixture()

      assert {:error, :unauthorized} = DeleteMemberById.call(member.id, MemberScope.for_member(user))
    end

    test "returns error if member is not found" do
      user = user_fixture(%{role: "ADMIN"})
      assert {:error, :not_found} = DeleteMemberById.call(-1, UserScope.for_user(user))
    end

    test "returns error if user is not authorized" do
      user = user_fixture(%{role: "COLLABORATOR"})
      member = member_fixture(%{user_id: user.id})

      assert {:error, :unauthorized} = DeleteMemberById.call(member.id, UserScope.for_user(user))
    end
  end
end
