defmodule ViewOfficeWeb.SessionsAuth do
  @moduledoc """
  Handles collaborator session authentication in the web interface.

  This module is responsible for managing sign-in and sign-out logic,
  including JWT token generation and session handling using Guardian.

  It integrates with LiveView via `:live_socket_id` to allow per-session identification
  and real-time session management, such as broadcasting disconnect events.
  """

  use ViewOfficeWeb, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  alias ViewOffice.Auth.Guardian

  @doc """
  Signs in a collaborator by generating a JWT token and initializing a secure session.

  The session is renewed to prevent session fixation attacks, and the token
  is stored in the session for later verification.

  ## Parameters

    - `conn`: The current Plug connection.
    - `collaborator`: The authenticated collaborator struct.

  ## Side Effects

    - Stores the JWT token and a LiveView socket ID in the session.
    - Sets a flash message welcoming the collaborator.
    - Redirects to the home page (`/`).

  ## Example

      sign_in(conn, %Collaborator{id: 1, name: "João", role: "admin"})
  """
  def sign_in(conn, collaborator) do
    {:ok, token, _claims} =
      Guardian.generate_token(collaborator, :main_token, collaborator.role)

    {:ok, refresh_token, _claims} =
      Guardian.generate_token(collaborator, :refresh_token, collaborator.role)

    conn
    |> renew_session()
    |> put_token_in_session(token)
    |> put_refresh_cookie(refresh_token)
    |> put_flash(:info, "Welcome back, #{collaborator.name}!")
    |> redirect(to: ~p"/dashboard")
  end

  @doc """
  Signs out the current user by dropping the session and redirecting to the login page.

  ## Parameters

    - `conn`: The current Plug connection.

  ## Example

      sign_out(conn)
  """
  def sign_out(conn) do
    conn
    |> configure_session(drop: true)
    |> delete_resp_cookie("refresh_token")
  end

  @doc false
  defp renew_session(conn) do
    delete_csrf_token()

    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  @doc false
  defp put_token_in_session(conn, token) do
    conn
    |> put_session(:collaborator_token, token)
    |> put_session(:live_socket_id, "collaborators_sessions:#{Base.url_encode64(token)}")
  end

  defp put_refresh_cookie(conn, refresh_token) do
    put_resp_cookie(conn, "refresh_token", refresh_token,
      http_only: true,
      # true in production -> HTTPS only
      secure: false,
      same_site: "Lax",
      # 10 dias
      max_age: 60 * 60 * 24 * 10
    )
  end
end
