defmodule ViewOffice.Members.Member do
  use Ecto.Schema
  import Ecto.Changeset

  schema "members" do
    belongs_to :user, ViewOffice.Accounts.User
    belongs_to :project, ViewOffice.Projects.Project
    has_many :member_roles, ViewOffice.Members.MemberRoles
    timestamps()
  end

  def changeset(member, attrs) do
    member
    |> cast(attrs, [:user_id, :project_id])
    |> validate_required([:user_id, :project_id])
  end
end
