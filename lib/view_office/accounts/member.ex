defmodule ViewOffice.Accounts.Member do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer(),
          user_id: integer(),
          project_id: integer(),
          role: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @roles ["Tech Manager", "PM", "Tech Lead", "Developer", "QA", "Designer", "DevOps"]

  schema "members" do
    field :role, :string
    belongs_to :user, ViewOffice.Accounts.User
    belongs_to :project, ViewOffice.Projects.Project
    timestamps()
  end

  def changeset(member, attrs) do
    member
    |> cast(attrs, [:user_id, :project_id, :role])
    |> validate_required([:user_id, :project_id, :role])
    |> validate_inclusion(:role, @roles)
  end
end
