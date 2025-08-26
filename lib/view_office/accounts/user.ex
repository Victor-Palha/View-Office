defmodule ViewOffice.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer(),
          email: String.t(),
          name: String.t(),
          password_hash: String.t(),
          password: String.t() | nil,
          role: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @roles ["COLLABORATOR", "ADMIN"]

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :role, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password, :role])
    |> validate_required([:email, :name, :password, :role])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:email, max: 160)
    |> validate_format(:email, ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)
    |> validate_inclusion(:role, @roles)
    |> validate_length(:name, min: 2, max: 100)
    |> maybe_put_password_hash()
    |> remove_password()
  end

  defp put_password_hash(changeset) do
    if password = get_change(changeset, :password) do
      change(changeset, password_hash: Argon2.hash_pwd_salt(password))
    else
      changeset
    end
  end

  defp maybe_put_password_hash(changeset) do
    if get_change(changeset, :password) do
      put_password_hash(changeset)
    else
      changeset
    end
  end

  defp remove_password(changeset) do
    change(changeset, password: nil)
  end
end
