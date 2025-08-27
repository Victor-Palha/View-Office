defmodule ViewOffice.Scopes.Member do
  @moduledoc """
  Defines the scope of a member within a project.
  """

  alias ViewOffice.Accounts.Member

  defstruct member: nil
  @type t :: %__MODULE__{
          member: Member.t() | nil
        }

  @doc """
  Creates a scope for the given member.

  Returns nil if no member is given.
  """
  def for_all_members(%Member{} = member) do
    %__MODULE__{member: member}
  end

  def for_all_members(nil), do: nil

  def for_managers(%Member{role: role} = member) when role in ["Tech Manager", "PM", "Tech Lead"] do
    %__MODULE__{member: member}
  end

  def for_managers(nil), do: nil
end
