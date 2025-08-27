defmodule ViewOffice.Members.MemberRoles do
  use Ecto.Schema
  import Ecto.Changeset

  schema "member_roles" do
    belongs_to :member, ViewOffice.Members.Member
    belongs_to :roles, ViewOffice.Roles.Roles
    timestamps()
  end

  def changeset(member_role, attrs) do
    member_role
    |> cast(attrs, [:member_id, :roles_id])
    |> validate_required([:member_id, :roles_id])
  end
end
