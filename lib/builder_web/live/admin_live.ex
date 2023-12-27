defmodule BuilderWeb.AdminLive do
  use BuilderWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>Admin</h1>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
