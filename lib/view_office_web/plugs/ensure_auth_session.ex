defmodule ViewOfficeWeb.Plugs.EnsureAuthSession do
  use ViewOfficeWeb, :verified_routes

  @moduledoc """
  Ensures that the user is authenticated by checking for a valid session.
  """

  import Phoenix.Controller
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns[:current_collaborator] do
      conn
    else
      conn
      |> redirect(to: ~p"/login")
      |> halt()
    end
  end
end
