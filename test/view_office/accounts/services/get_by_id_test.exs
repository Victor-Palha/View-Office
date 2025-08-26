defmodule ViewOffice.Accounts.Services.GetByIdTest do
  use ViewOffice.DataCase
  alias ViewOffice.Accounts.Services.GetById
  alias ViewOffice.Scopes.User, as: UserScope

  describe "Get User by ID" do
    import ViewOffice.UserFixtures

    test "Should be able to get user by ID" do
      user_logged_in = user_fixture(%{
        email: "logged_in@example.com",
        name: "Logged In User",
        password: "password",
        role: "ADMIN"
      })
      user_to_search = user_fixture()

      {:ok, response} = GetById.call(user_to_search.id, UserScope.for_user(user_logged_in))
      assert response.id == user_to_search.id
      assert response.email == user_to_search.email
      assert response.name == user_to_search.name
      assert response.role == user_to_search.role
    end

    test "Should return :not_found if user does not exist" do
      user_logged_in = user_fixture(%{
        email: "logged_in@example.com",
        name: "Logged In User",
        password: "password",
        role: "ADMIN"
      })

      assert {:error, :not_found} = GetById.call(-1, UserScope.for_user(user_logged_in))
    end
  end
end
