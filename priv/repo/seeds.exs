# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ViewOffice.Repo.insert!(%ViewOffice.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ViewOffice.Repo
alias ViewOffice.Accounts.User

admin_attrs = %{
  name: "Victor Palha",
  email: "admin@ocp.dev",
  # será criptografada no changeset
  password: "supersecret",
  role: "ADMIN",
}

%User{}
|> User.changeset(admin_attrs)
|> Repo.insert!()

IO.puts("✅ Admin user created!")
