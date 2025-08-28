defmodule ViewOffice.Auth.AuthenticatorTest do
  use ViewOffice.DataCase
  alias ViewOffice.Auth.Authenticator

  describe "Authenticate Users" do
    import ViewOffice.UserFixtures
    alias ViewOffice.Accounts.User

    test "Should be able to authenticate a user" do
      user_fixture(%{
        email: "john@doe.com",
        password: "123456"
      })

      valid_attrs = %{
        email: "john@doe.com",
        password: "123456"
      }

      assert {:ok, %User{}} =
               Authenticator.call(valid_attrs)
    end

    test "Should not be able to authenticate a user with invalid email" do
      user_fixture()

      invalid_attrs = %{
        email: "jane@doe.com",
        password: "123456"
      }

      assert {:error, :invalid_credentials} =
               Authenticator.call(invalid_attrs)
    end

    test "Should not be able to authenticate a user with invalid password" do
      user_fixture(%{
        email: "john@doe.com",
        password: "123456"
      })

      invalid_attrs = %{
        email: "john@doe.com",
        password: "654321"
      }

      assert {:error, :invalid_credentials} =
               Authenticator.call(invalid_attrs)
    end
  end
end
