defmodule ViewOffice.Accounts.Services.CreateTest do
  use ViewOffice.DataCase
  alias ViewOffice.Accounts.Services.Create

  describe "Create user" do
    alias ViewOffice.Accounts.User

    test "Should be able to create an ADMIN user" do
      valid_attrs = %{
        email: "test@example.com",
        name: "Test User",
        password: "password",
        role: "ADMIN"
      }

      assert {:ok, %User{} = user} = Create.call(valid_attrs)
      assert user.email == valid_attrs.email
      assert user.name == valid_attrs.name
      assert user.role == valid_attrs.role
      assert user.password_hash != nil
    end
  end
end
