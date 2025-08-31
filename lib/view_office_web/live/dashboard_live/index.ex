defmodule ViewOfficeWeb.DashboardLive.Index do
  use ViewOfficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(
       active: "/dashboard",
       sidebar_collapsed: false
     )}
  end

  @impl true
  def handle_event("toggle-sidebar", _, socket) do
    {:noreply, update(socket, :sidebar_collapsed, fn collapsed -> !collapsed end)}
  end
end
