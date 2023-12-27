defmodule BuilderWeb.OnMount do
  use BuilderWeb, :verified_routes

  import Phoenix.Component, only: [assign_new: 3]
  import Phoenix.LiveView, only: [redirect: 2]

  alias Builder.Accounts.User

  def on_mount(:redirect_if_admin, _params, session, socket) do
    socket = assign_new(socket, :user, fn ->
      Map.fetch!(session, "user")
    end)

    if User.is_role(socket.assigns.user, "admin") do
      {:halt, redirect(socket, to: ~p"/admin")}
    else
      {:cont, socket}
    end
  end

  def on_mount(:redirect_if_anon, _params, session, socket) do
    socket = assign_new(socket, :user, fn ->
      Map.fetch!(session, "user")
    end)

    if User.is_role(socket.assigns.user, "admin") do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: ~p"/login")}
    end
  end
end
