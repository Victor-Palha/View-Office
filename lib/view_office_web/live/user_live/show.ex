defmodule ViewOfficeWeb.UserLive.Show do
  use ViewOfficeWeb, :live_view

  alias ViewOffice.Accounts.Services
  alias ViewOffice.Scopes.User, as: UserScope

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:sidebar_collapsed, false)
      |> assign(:current_user, socket.assigns.current_user)
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:ok, user} = Services.GetById.call(id, UserScope.for_user(socket.assigns.current_user))

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user, user)
     |> assign(:skills, user.skills)}
  end

  defp page_title(:show), do: "Show User"
  defp page_title(:edit), do: "Edit User"
end
