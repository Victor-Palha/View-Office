defmodule ViewOffice.Repo.Migrations.CreateUserTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :name, :string
      add :password_hash, :string
      add :role, :string
      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])
  end
end
