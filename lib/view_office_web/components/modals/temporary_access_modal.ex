defmodule ViewOfficeWeb.Modals.TemporaryAccessModal do
  use Phoenix.Component
  import ViewOfficeWeb.CoreComponents, only: [icon: 1]

  attr :show, :boolean, default: false
  attr :on_close, :string, default: "close-password-modal"
  attr :new_user_password, :string, default: nil
  attr :recent_user_email, :string, default: nil

  def render(assigns) do
    ~H"""
    <div
      :if={@show}
      id="show-temporary-access-modal"
      class="fixed inset-0 z-50 flex items-center justify-center"
      role="dialog"
      aria-modal="true"
    >
      <!-- Overlay que fecha o modal -->
      <div
        class="fixed inset-0 bg-black/75"
        aria-hidden="true"
      >
      </div>

    <!-- Conteúdo do modal -->
      <div
        class="relative bg-white dark:bg-gray-800 rounded-lg px-6 py-5 shadow-xl sm:max-w-md sm:w-full z-10"
        phx-key="escape"
      >
        <!-- Icon -->
        <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-blue-100 dark:bg-blue-900">
          <.icon name="hero-key" class="h-6 w-6 text-blue-600 dark:text-blue-300" />
        </div>

    <!-- Content -->
        <div class="mt-3 text-center sm:mt-5">
          <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-white">
            Temporary Password Generated
          </h3>
          <p class="mt-2 text-sm text-gray-500 dark:text-gray-300">
            This password will be used by
            <strong class="text-gray-700 dark:text-gray-200">{@recent_user_email}</strong>
            to access the system.
            Please copy and send it to them, as it won't be displayed again.
          </p>

    <!-- Password -->
          <div class="mt-4 px-4 py-3 bg-gray-50 dark:bg-gray-700 rounded-md">
            <div class="relative">
              <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <.icon
                  name="hero-document-duplicate"
                  class="h-5 w-5 text-gray-400 dark:text-gray-300"
                />
              </div>
              <input
                type="text"
                readonly
                value={@new_user_password}
                class="block w-full pl-10 pr-12 py-2 bg-white dark:bg-gray-600 border border-gray-300 dark:border-gray-500 rounded-md text-center font-mono text-gray-800 dark:text-gray-100 focus:outline-none focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
          </div>
        </div>

    <!-- Footer -->
        <div class="mt-5 sm:mt-6">
          <button
            phx-click={@on_close}
            type="button"
            class="w-full px-4 py-2 bg-blue-600 text-white rounded-md shadow hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:text-sm"
          >
            Close
          </button>
        </div>
      </div>
    </div>
    """
  end
end
