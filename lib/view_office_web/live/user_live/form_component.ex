defmodule ViewOfficeWeb.UserLive.FormComponent do
  use ViewOfficeWeb, :live_component

  alias ViewOffice.Accounts.User
  alias ViewOffice.Accounts.Services
  alias ViewOffice.Auth.GenRandomPass
    alias ViewOffice.Scopes.User, as: UserScope

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <form
        id="user-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="bg-white dark:bg-gray-800 p-6 rounded-lg"
      >
        <div class="mt-4 space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-200">Name</label>
            <.input
              field={@form[:name]}
              type="text"
            />
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-200">Email</label>
            <.input
              field={@form[:email]}
              type="email"
            />
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-200">Role</label>
            <.input
              field={@form[:role]}
              type="select"
              name="user[role]"
              options={["ADMIN", "COLLABORATOR"]}
            />
          </div>
        </div>

        <div class="mt-6 flex justify-end space-x-2">
          <button
            type="submit"
            data-confirm={
              if @action == :edit do
                "Are you sure you want to save changes?"
              else
                "Are you sure you want to create this user?"
              end
            }
            class="px-4 py-2 bg-green-600 text-white rounded-md text-sm hover:bg-green-700"
          >
            <%= if @action == :edit do %>
              Save Changes
            <% else %>
              Create User
            <% end %>
          </button>
        </div>
      </form>
    </div>
    """
  end

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = User.changeset(user, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = User.changeset(socket.assigns.user, user_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    save_user(socket, socket.assigns.action, user_params)
  end

  defp save_user(socket, :edit, user_params) do
    case Services.Update.call(socket.assigns.user, user_params, UserScope.for_user(socket.assigns.current_user)) do
      {:ok, user} ->
        notify_parent({:updated, user})
        {:noreply, socket |> put_flash(:info, "User updated successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_user(socket, :new, %{
         "name" => name,
         "email" => email,
         "role" => role
       }) do
    random_pass = GenRandomPass.call()
    IO.inspect(random_pass, label: "Generated password")
    params = %{
      name: name,
      email: email,
      role: role,
      password: random_pass,
    }
    IO.inspect(socket.assigns)
    case Services.Create.call(params, UserScope.for_user(socket.assigns.current_user)) do
      {:ok, user} ->
        user = Map.put(user, :password, random_pass)
        notify_parent({:saved, user})
        {:noreply, socket |> put_flash(:info, "User created successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
