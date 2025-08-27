defmodule ViewOffice.Repo.Migrations.CreateMemberAndRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:roles, [:name])

    create table(:members) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :project_id, references(:projects, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:members, [:project_id, :user_id])

    create table(:member_roles) do
      add :member_id, references(:members, on_delete: :nothing), null: false
      add :roles_id, references(:roles, on_delete: :nothing), null: false

      timestamps()
    end
  end
end
