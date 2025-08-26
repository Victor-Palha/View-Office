defmodule ViewOffice.Accounts.Services.AllTest do
alias ViewOffice.Accounts.User
  use ViewOffice.DataCase
  alias ViewOffice.Accounts.Services.All
  alias ViewOffice.Scopes.User, as: UserScope

  describe "Fetch all users" do
    import ViewOffice.UserFixtures

    test "Should return all users" do
      user1 = user_fixture(%{
        email: "user1@example.com"
      })
      user2 = user_fixture(%{
        email: "user2@example.com"
      })

      assert All.call(UserScope.for_user(user1)) == [user1, user2]
    end

    test "Should return empty list if no users exist" do
      mock_user = %User{
        email: "mock@example.com",
        name: "Logged In User",
        password: "password",
        role: "ADMIN"
      }

      assert All.call(UserScope.for_user(mock_user)) == []
    end
  end
end
