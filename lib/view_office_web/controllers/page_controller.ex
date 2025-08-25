defmodule ViewOfficeWeb.PageController do
  use ViewOfficeWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
