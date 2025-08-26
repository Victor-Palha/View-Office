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

    test "Should be able to create an COLLABORATOR user" do
      valid_attrs = %{
        email: "test@example.com",
        name: "Test User",
        password: "password",
        role: "COLLABORATOR"
      }

      assert {:ok, %User{} = user} = Create.call(valid_attrs)
      assert user.email == valid_attrs.email
      assert user.name == valid_attrs.name
      assert user.role == valid_attrs.role
      assert user.password_hash != nil
    end

    test "Should not be able to create an user with role different from ADMIN or COLLABORATOR" do
      valid_attrs = %{
        email: "test@example.com",
        name: "Test User",
        password: "password",
        role: "GUEST"
      }

      assert {:error, changeset} = Create.call(valid_attrs)
      assert "is invalid" in errors_on(changeset).role
    end

    test "Should not be able to create an user with invalid email" do
      invalid_attrs = %{
        email: "invalid_email",
        name: "Test User",
        password: "password",
        role: "ADMIN"
      }

      assert {:error, changeset} = Create.call(invalid_attrs)
      assert "has invalid format" in errors_on(changeset).email
    end

    test "Should not be able to create 2 users with same e-mail" do
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

      assert {:error, changeset} = Create.call(valid_attrs)
      assert "has already been taken" in errors_on(changeset).email
    end
  end
end
