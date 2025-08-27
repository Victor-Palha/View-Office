defmodule ViewOffice.Repo.Migrations.DropRolesTable do
  use Ecto.Migration

  def change do
    alter table(:members) do
      add :role, :string, null: false
    end

    drop table(:member_roles)
    drop table(:roles)
  end
end
