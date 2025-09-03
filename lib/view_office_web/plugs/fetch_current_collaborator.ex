defmodule ViewOfficeWeb.Plugs.FetchCurrentCollaborator do
  @moduledoc """
  Plug to authenticate a collaborator using a token stored in the session or fallback
  to refresh token in the cookie. On success, assigns the current collaborator to conn.
  """
  @behaviour Plug

  import Plug.Conn
  alias ViewOffice.Accounts.User
  alias ViewOffice.Auth.Guardian

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    with {:ok, token} <- recover_token(conn),
         {:ok, claims} <- verify_token(token),
         {:ok, collaborator} <- get_collaborator(claims["sub"]) do
      conn
      |> put_session(:user_token, token)
      |> assign(:current_user, collaborator)
    else
      {:error, _reason} ->
        # If the token is invalid or expired, try to refresh it using the refresh token
        case try_refresh_token(conn) do
          {:ok, token, collaborator} ->
            conn
            |> put_session(:user_token, token)
            |> assign(:current_user, collaborator)

          {:error, _} ->
            assign(conn, :current_user, nil)
        end
    end
  end

  defp recover_token(conn) do
    case get_session(conn, :user_token) do
      nil -> {:error, :no_token}
      token -> {:ok, token}
    end
  end

  defp verify_token(token) do
    Guardian.verify_token(token)
  end

  defp get_collaborator(id) do
    case ViewOffice.Accounts.Services.GetById.fetch(id) do
      {:ok, user} -> {:ok, user}
      {:error, :not_found} -> {:error, :not_found}
    end
  end

  defp try_refresh_token(conn) do
    with {:ok, refresh_token} <- fetch_refresh_cookie(conn),
         {:ok, claims} <- Guardian.verify_token_type(refresh_token, "refresh"),
         {:ok, %User{} = user} <- get_collaborator(claims["sub"]),
         {:ok, new_token, _} <-
           Guardian.generate_token(user, :main_token, user.role) do
      {:ok, new_token, user}
    else
      _ -> {:error, :refresh_failed}
    end
  end

  defp fetch_refresh_cookie(conn) do
    case conn.req_cookies["refresh_token"] do
      nil ->
        {:error, :no_cookie}

      token ->
        {:ok, token}
    end
  end
end
