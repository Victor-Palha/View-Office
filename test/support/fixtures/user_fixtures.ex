defmodule ViewOffice.UserFixtures do
  def user_fixture(attrs \\ %{}) do
    unique = System.unique_integer([:positive])

    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "test#{unique}@example.com",
        name: "Test User",
        password: "password",
        role: "ADMIN"
      })
      |> ViewOffice.Accounts.Services.Create.call()

    user
  end
end
