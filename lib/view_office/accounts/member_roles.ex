defmodule ViewOffice.Accounts.MemberRoles do
  use Ecto.Schema
  import Ecto.Changeset

  schema "member_roles" do
    belongs_to :member, ViewOffice.Accounts.Member
    belongs_to :roles, ViewOffice.Accounts.Roles
    timestamps()
  end

  def changeset(member_role, attrs) do
    member_role
    |> cast(attrs, [:member_id, :roles_id])
    |> validate_required([:member_id, :roles_id])
  end
end
