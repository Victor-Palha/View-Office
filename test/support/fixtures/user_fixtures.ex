defmodule ViewOffice.UserFixtures do
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "test@example.com",
        name: "Test User",
        password: "password",
        role: "ADMIN"
      })
      |> ViewOffice.Accounts.Services.Create.call()

    user
  end
end
