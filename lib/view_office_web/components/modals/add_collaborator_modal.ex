defmodule ViewOfficeWeb.Modals.AddCollaboratorModal do
  use Phoenix.Component

  attr :show, :boolean, default: false
  attr :on_close, :string, default: "hide-new-user-modal"

  def render(assigns) do
    assigns =
      assign(assigns,
        roles: ["ADMIN", "COLLABORATOR"]
      )

    ~H"""
    <div
      :if={@show}
      id="add-user-modal"
      class="fixed z-50 inset-0 overflow-y-auto"
      phx-click-away={@on_close}
      phx-window-keydown={@on_close}
      phx-key="escape"
    >
      <div class="flex items-center justify-center min-h-screen px-4">
        <div class="fixed inset-0 bg-gray-900 bg-opacity-50 transition-opacity" />

        <div class="bg-white dark:bg-gray-800 rounded-lg overflow-hidden shadow-xl transform transition-all sm:max-w-lg sm:w-full z-50">
          <div class="px-6 py-4">
            <h2 class="text-lg font-medium text-gray-900 dark:text-white">Add User</h2>
            <form phx-submit="save-user">
              <div class="mt-4 space-y-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 dark:text-gray-200">
                    Name
                  </label>
                  <input
                    name="name"
                    type="text"
                    class="mt-1 w-full rounded-md border-gray-300 dark:bg-gray-700 dark:text-white"
                  />
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 dark:text-gray-200">
                    Email
                  </label>
                  <input
                    name="email"
                    type="email"
                    class="mt-1 w-full rounded-md border-gray-300 dark:bg-gray-700 dark:text-white"
                  />
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 dark:text-gray-200">
                    Role
                  </label>
                  <select
                    name="role"
                    class="mt-1 w-full rounded-md border-gray-300 dark:bg-gray-700 dark:text-white"
                  >
                    <%= for role <- @roles do %>
                      <option value={role}>{String.capitalize(role)}</option>
                    <% end %>
                  </select>
                </div>
              </div>

              <div class="mt-6 flex justify-end space-x-2">
                <button
                  type="button"
                  phx-click={@on_close}
                  class="px-4 py-2 bg-gray-300 dark:bg-gray-600 rounded-md text-sm text-gray-800 dark:text-white"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  class="px-4 py-2 bg-green-600 text-white rounded-md text-sm hover:bg-green-700"
                >
                  Save
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
