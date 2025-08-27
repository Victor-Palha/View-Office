defmodule ViewOffice.Projects.Services.CreateTest do
  use ViewOffice.DataCase
  alias ViewOffice.Projects.Services.Create
  alias ViewOffice.Scopes.User, as: UserScope

  describe "Create Project" do
    import ViewOffice.UserFixtures

    test "Should be able to create a Project" do
      user = user_fixture(%{
        role: "ADMIN"
      })

      assert {:ok, project} = Create.call(%{
        name: "Test Project",
        description: "A sample project for testing"
      }, UserScope.for_user(user))

      assert project.name == "Test Project"
      assert project.description == "A sample project for testing"
    end

    test "Should not be able to create a Project with invalid data" do
      user = user_fixture(%{
        role: "ADMIN"
      })

      assert {:error, changeset} = Create.call(%{
        name: "",
        description: "A sample project for testing"
      }, UserScope.for_user(user))

      assert changeset.errors[:name] == {"can't be blank", [validation: :required]}
    end

        test "Should not be able to create a Project from a non ADMIN user" do
      user = user_fixture(%{
        role: "COLLABORATOR"
      })

      assert {:error, :unauthorized} = Create.call(%{
        name: "Banana",
        description: "A sample project for testing"
      }, UserScope.for_user(user))
    end
  end
end
