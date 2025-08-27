defmodule ViewOffice.Repo.Migrations.OnDeleteProject do
  use Ecto.Migration

  def change do
    drop constraint(:members, "members_project_id_fkey")
    drop constraint(:members, "members_user_id_fkey")

    alter table(:members) do
      modify :project_id, references(:projects, on_delete: :delete_all), null: false
      modify :user_id, references(:users, on_delete: :delete_all), null: false
    end
  end
end
