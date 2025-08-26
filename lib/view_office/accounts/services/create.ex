defmodule ViewOffice.Accounts.Services.Create do
  alias ViewOffice.Accounts.User
  alias ViewOffice.Repo

  @spec call(map()) :: {:ok, any()} | {:error, Ecto.Changeset.t()}
  def call(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
