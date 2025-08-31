defmodule ViewOfficeWeb.Plugs.RedirectIfAuthenticated do
  use ViewOfficeWeb, :verified_routes

  @moduledoc """
  Redirects to `/dashboard` if the user is already authenticated.
  """

  import Phoenix.Controller
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns[:current_collaborator] do
      conn
      |> redirect(to: ~p"/dashboard")
      |> halt()
    else
      IO.inspect(conn.assigns[:current_collaborator], label: "Not authenticated")
      conn
    end
  end
end
