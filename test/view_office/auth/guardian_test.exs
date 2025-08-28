defmodule ViewOffice.Auth.GuardianTest do
  use ExUnit.Case, async: true
  alias ViewOffice.Auth.Guardian

  @valid_entity %{id: 123}
  @valid_role "ADMIN"
  @invalid_token "invalid_token"

  describe "generate_token/3" do
    test "generates a main token" do
      {:ok, token, _claims} = Guardian.generate_token(@valid_entity, :main_token, @valid_role)
      assert is_binary(token)

      {:ok, claims} = Guardian.verify_token(token)
      assert claims["typ"] == "main"
      assert claims["role"] == @valid_role
    end

    test "generates a refresh token" do
      {:ok, token, _claims} = Guardian.generate_token(@valid_entity, :refresh_token, @valid_role)
      assert is_binary(token)

      {:ok, claims} = Guardian.verify_token(token)
      assert claims["typ"] == "refresh"
      assert claims["role"] == @valid_role
    end

    test "generates a temporary token" do
      {:ok, token, _claims} =
        Guardian.generate_token(@valid_entity, :temporary_token, @valid_role)

      assert is_binary(token)

      {:ok, claims} = Guardian.verify_token(token)
      assert claims["typ"] == "temporary"
      assert claims["role"] == @valid_role
    end
  end

  describe "verify_token/1" do
    test "verifies a valid token" do
      {:ok, token, _claims} = Guardian.generate_token(@valid_entity, :main_token, @valid_role)
      assert {:ok, _claims} = Guardian.verify_token(token)
    end

    test "returns error for an invalid token" do
      assert {:error, :invalid_token} = Guardian.verify_token(@invalid_token)
    end
  end

  describe "verify_token_type/2" do
    test "verifies correct token type" do
      {:ok, token, _claims} = Guardian.generate_token(@valid_entity, :main_token, @valid_role)
      assert {:ok, _claims} = Guardian.verify_token_type(token, "main")
    end

    test "returns error for incorrect token type" do
      {:ok, token, _claims} = Guardian.generate_token(@valid_entity, :main_token, @valid_role)
      assert {:error, "Invalid token type"} = Guardian.verify_token_type(token, "refresh")
    end
  end
end
