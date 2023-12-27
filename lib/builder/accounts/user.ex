defmodule Builder.Accounts.User do

  defstruct role: "anon" 

  def new() do
    %__MODULE__{}
  end

  def set_role(%__MODULE__{} = user, role) do
    %__MODULE__{user | role: role}
  end

  def is_role(%__MODULE__{role: user_role}, ask_role) do
    user_role == ask_role
  end
end
