defmodule ViewOffice.Repo do
  use Ecto.Repo,
    otp_app: :view_office,
    adapter: Ecto.Adapters.Postgres
end
