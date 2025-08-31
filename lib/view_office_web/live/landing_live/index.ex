defmodule ViewOfficeWeb.LandingLive.Index do
  use ViewOfficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(
       page_title: "ViewOffice - OCP",
       mobile_menu_open: false
     )}
  end

  @impl true
  def handle_event("toggle-mobile-menu", _, socket) do
    {:noreply, update(socket, :mobile_menu_open, &(!&1))}
  end
end
