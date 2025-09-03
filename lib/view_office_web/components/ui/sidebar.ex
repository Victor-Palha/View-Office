defmodule ViewOfficeWeb.Ui.Sidebar do
  use Phoenix.Component
  import ViewOfficeWeb.CoreComponents, only: [icon: 1]

  attr :current_user, :map, required: true
  attr :collapsed, :boolean, default: false
  attr :active, :string, default: "/dashboard"

  def call(assigns) do
    ~H"""
    <div class={[
      "h-screen bg-white dark:bg-gray-900 border-r dark:border-gray-800 flex flex-col transition-all duration-150 relative",
      @collapsed && "w-20",
      !@collapsed && "w-80"
    ]}>
      <!-- Toggle Button -->
      <div class="p-2 flex justify-end">
        <button phx-click="toggle-sidebar">
          <.icon
            name="hero-bars-3"
            class="w-7 h-7 text-gray-600 dark:text-gray-300 hover:text-primary"
          />
        </button>
      </div>

    <!-- Header -->
      <div class="p-4 flex items-center justify-center border-b dark:border-gray-800 mb-6">
        <div class="flex items-center space-x-2">
          <h1 :if={!@collapsed} class="text-lg font-bold text-gray-900 dark:text-white">
            View Office - OCP
          </h1>
          <p :if={@collapsed} class="text-md text-gray-900 dark:text-white">OCP</p>
        </div>
      </div>

    <!-- Content -->
      <div class="px-2 space-y-6">
        <div>
          <p :if={!@collapsed} class="text-xs text-gray-500 dark:text-gray-400 uppercase mb-2">
            Main
          </p>
          <.sidebar_link
            href="/dashboard"
            icon="hero-home"
            label="Dashboard"
            active={@active}
            collapsed={@collapsed}
          />
        </div>

        <div>
          <p :if={!@collapsed} class="text-xs text-gray-500 dark:text-gray-400 uppercase mb-2">
            Management
          </p>
          <.sidebar_link
            href="/projects"
            icon="hero-briefcase"
            label="Projects"
            active={@active}
            collapsed={@collapsed}
          />
          <.sidebar_link
            href="/users"
            icon="hero-users"
            label="Users"
            active={@active}
            collapsed={@collapsed}
          />
        </div>

        <div>
          <p :if={!@collapsed} class="text-xs text-gray-500 dark:text-gray-400 uppercase mb-2">
            Settings
          </p>
          <.sidebar_link
            href="/settings"
            icon="hero-cog-6-tooth"
            label="Settings"
            active={@active}
            collapsed={@collapsed}
          />
        </div>
      </div>

    <!-- Footer -->
      <footer class="px-2 py-3 mt-auto border-t border-gray-200 dark:border-gray-700">
        <div class={[
          "flex items-center rounded-lg p-2 transition-all",
          "hover:bg-gray-50 dark:hover:bg-gray-800",
          if(@collapsed, do: "justify-center", else: "justify-between")
        ]}>
          <div class="flex items-center space-x-3 min-w-0">
            <div class="h-8 w-8 rounded-full bg-gray-300 dark:bg-gray-700 flex items-center justify-center text-gray-600 dark:text-gray-200 font-medium flex-shrink-0">
              {String.first(@current_user.name)}
            </div>
            <%= if !@collapsed do %>
              <div class="truncate">
                <p class="text-sm font-medium text-gray-700 dark:text-gray-200 truncate">
                  {@current_user.name}
                </p>
                <p class="text-xs text-gray-500 dark:text-gray-400 truncate">
                  {@current_user.email || "Admin"}
                </p>
              </div>
            <% end %>
          </div>

          <%= if !@collapsed do %>
            <form method="post" action="/auth/logout">
              <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
              <button
                class="p-1 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 flex-shrink-0"
                title="Logout"
                aria-label="Logout"
              >
                <.icon
                  name="hero-arrow-right-end-on-rectangle"
                  class="w-5 h-5 text-gray-500 dark:text-gray-300 hover:text-red-500"
                />
              </button>
            </form>
          <% end %>
        </div>
      </footer>
    </div>
    """
  end

  attr :collapsed, :boolean, default: false
  attr :href, :string, required: true
  attr :icon, :string, required: true
  attr :label, :string, required: true
  attr :active, :string, default: "/dashboard"
  attr :is_active, :boolean, default: false

  defp sidebar_link(assigns) do
    assigns = assign(assigns, is_active: assigns.active == assigns.href)

    ~H"""
    <.link
      navigate={@href}
      class={[
        "flex items-center px-2 py-2 rounded-md text-sm font-medium transition-colors",
        @is_active && "bg-primary text-white",
        !@is_active && "text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800",
        @collapsed && "justify-center"
      ]}
    >
      <.icon name={@icon} class="w-5 h-5" />
      <span :if={!@collapsed} class="ml-2">{@label}</span>
    </.link>
    """
  end
end
