defmodule ViewOfficeWeb.Plugs.EnsureAuthLiveSession do
  @moduledoc """
  Provides LiveView `on_mount` hooks for session-based authentication and role-based access control.

  ## Hooks

    - `:mount_current_collaborator`: Assigns the current authenticated collaborator to the socket if present.
    - `:ensure_authenticated`: Ensures the user is authenticated; otherwise redirects to `/login`.
    - `{:ensure_authenticated_with_role, role}`: Ensures the user has the exact required role.
    - `{:ensure_authenticated_with_roles, roles}`: Ensures the user has one of the allowed roles.

  This module expects a `collaborator_token` to be present in the session.
  If present, it will be verified using `Guardian`, and a `Collaborator` will be fetched and assigned.
  """

  use ViewOfficeWeb, :verified_routes

  alias Phoenix.LiveView
  alias Phoenix.Component
  alias ViewOffice.Accounts.User
  alias ViewOffice.Auth.Guardian

  @roles ["COLLABORATOR", "ADMIN"]

  def on_mount(:mount_current_collaborator, _params, session, socket) do
    {:cont, mount_current_collaborator(socket, session)}
  end

  def on_mount(:ensure_authenticated, _params, session, socket) do
    socket = mount_current_collaborator(socket, session)

    if socket.assigns[:current_user] do
      {:cont, socket}
    else
      redirect_unauthenticated(socket)
    end
  end

  def on_mount({:ensure_authenticated_with_role, required_role}, _params, session, socket)
      when required_role in @roles do
    socket = mount_current_collaborator(socket, session)

    case socket.assigns[:current_user] do
      %User{role: ^required_role} -> {:cont, socket}
      %User{} -> redirect_unauthorized(socket)
      _ -> redirect_unauthenticated(socket)
    end
  end

  def on_mount({:ensure_authenticated_with_roles, allowed_roles}, _params, session, socket)
      when is_list(allowed_roles) do
    if Enum.all?(allowed_roles, fn role -> role in @roles end) do
      socket = mount_current_collaborator(socket, session)

      case socket.assigns[:current_user] do
        %User{role: role} ->
          if role in allowed_roles do
            {:cont, socket}
          else
            redirect_unauthorized(socket)
          end

        _ ->
          redirect_unauthenticated(socket)
      end
    else
      invalid_roles = Enum.reject(allowed_roles, fn role -> role in @roles end)

      raise ArgumentError,
            "Invalid roles: #{Enum.join(invalid_roles, ", ")}. Allowed roles are: #{Enum.join(@roles, ", ")}"
    end
  end

  def on_mount({:ensure_authenticated_with_role, invalid}, _params, _session, _socket)
      when invalid not in @roles do
    raise ArgumentError,
          "Invalid role: #{inspect(invalid)}. Allowed roles are: #{Enum.join(@roles, ", ")}"
  end

  def on_mount({:ensure_authenticated_with_roles, invalid_list}, _params, _session, _socket)
      when is_list(invalid_list) do
    invalid_roles = Enum.reject(invalid_list, &(&1 in @roles))

    if invalid_roles != [] do
      raise ArgumentError,
            "Invalid roles: #{Enum.join(invalid_roles, ", ")}. Allowed roles are: #{Enum.join(@roles, ", ")}"
    end
  end

  @doc false
  defp mount_current_collaborator(socket, session) do
    Component.assign_new(socket, :current_user, fn ->
      get_current_collaborator(session)
    end)
  end

  defp get_current_collaborator(%{"user_token" => token}) when not is_nil(token) do
    with {:ok, claims} <- Guardian.verify_token_type(token, "main"),
         {:ok, %User{} = user} <-
           ViewOffice.Accounts.Services.GetById.fetch(claims["sub"]) do
      user
    else
      {:error, :token_expired} ->
        nil

      _ ->
        nil
    end
  end

  defp get_current_collaborator(_), do: nil

  defp redirect_unauthenticated(socket) do
    socket
    |> LiveView.put_flash(:error, "You must log in to access this page.")
    |> LiveView.redirect(to: ~p"/login")
    |> then(&{:halt, &1})
  end

  defp redirect_unauthorized(socket) do
    socket
    |> LiveView.put_flash(:error, "You do not have permission to access this page.")
    |> LiveView.redirect(to: ~p"/")
    |> then(&{:halt, &1})
  end
end
