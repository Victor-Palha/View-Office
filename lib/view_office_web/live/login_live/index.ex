defmodule ViewOfficeWeb.LoginLive.Index do
  use ViewOfficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    form =
      %{
        "email" => "",
        "password" => "",
        "remember_me" => false
      }
      |> to_form(as: :login)

    {:ok,
     socket
     |> assign(
       page_title: "Login - Open Collaborative Platform",
       form: form,
       error: nil
     )}
  end
end
