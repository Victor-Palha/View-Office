defmodule ViewOfficeWeb.AuthController do
  @moduledoc """
  Handles collaborator login logic via HTTP forms.

  Receives login data from the client, delegates authentication to the
  Authenticator service, and signs in the user if credentials are valid.

  Redirects to the login page with appropriate flash messages on failure.
  """

  use ViewOfficeWeb, :controller

  alias ViewOffice.Auth
  alias ViewOfficeWeb.SessionsAuth

  @doc """
  Handles POST /login.

  Authenticates the collaborator using the given email and password. On success,
  signs the user in and starts a session. On failure, redirects back to the login
  page with an error message.
  """
  def login(conn, %{"login" => %{"email" => email, "password" => password}}) do
    case Auth.Authenticator.call(%{email: email, password: password}) do
      {:ok, collaborator} ->
        SessionsAuth.sign_in(conn, collaborator)

      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> redirect(to: ~p"/login")
    end
  end

  @doc """
  Handles GET /logout.
  Signs out the current user and redirects to the dashboard.
  """
  def logout(conn, _params) do
    conn
    |> SessionsAuth.sign_out()
    |> redirect(to: ~p"/")
  end
end
