defmodule ViewOfficeWeb.UserLive.Index do
  use ViewOfficeWeb, :live_view

  alias ViewOffice.Accounts.User
  alias ViewOffice.Accounts.Services
  alias ViewOffice.Scopes.User, as: UserScope

  @impl true
  def mount(_params, _session, socket) do
    users = Services.All.call(UserScope.for_user(socket.assigns.current_user))
    socket =
      socket
      |> assign(:active, "/users")
      |> assign(:show_password_modal, false)
      |> assign(:new_user_password, nil)
      |> assign(:recent_user_email, nil)
      |> assign(:sidebar_collapsed, false)
      |> stream(:user_collection, users)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User")
    |> assign(:current_user, socket.assigns.current_user)
    |> assign(:user, Services.GetById.call!(id, UserScope.for_user(socket.assigns.current_user)))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User")
    |> assign(:user, %User{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "All Users")
    |> assign(:user, nil)
  end

  @impl true
  def handle_info({ViewOfficeWeb.UserLive.FormComponent, {:saved, user}}, socket) do
    socket =
      socket
      |> assign(:new_user_password, user.password)
      |> assign(:recent_user_email, user.email)
      |> assign(:show_password_modal, true)
      |> assign(:current_user, socket.assigns.current_user)
      |> put_flash(:info, "User created successfully.")
      |> stream_insert(:user_collection, user)

    {:noreply, socket}
  end

  @impl true
  def handle_info({ViewOfficeWeb.UserLive.FormComponent, {:updated, user}}, socket) do
    socket =
      socket
      |> put_flash(:info, "User updated successfully.")
      |> stream_insert(:user_collection, user)

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete-user", %{"id" => id}, socket) do
    case Services.DeleteById.call(id, UserScope.for_user(socket.assigns.current_user)) do
      {:ok, deleted_user} ->
        {:noreply,
         socket
         |> put_flash(:info, "User deleted successfully.")
         |> stream_delete(:user_collection, deleted_user)}

      {:error, :not_found} ->
        {:noreply,
         socket
         |> put_flash(:error, "User not found.")}
    end
  end

  @impl true
  def handle_event("toggle-sidebar", _, socket) do
    {:noreply, update(socket, :sidebar_collapsed, fn collapsed -> !collapsed end)}
  end

  @impl true
  def handle_event("close-password-modal", _, socket) do
    {:noreply,
     socket
     |> assign(:show_password_modal, false)
     |> assign(:new_user_password, nil)
     |> assign(:recent_user_email, nil)}
  end
end
