defmodule BuilderWeb.LoginLive do
  use BuilderWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.simple_form for={@form} id="login_form" action={~p"/users/login"} phx-update="ignore">
        <.input field={@form[:password]} type="password" label="Password" required />
        <:actions>
          <.button phx-disable-with="Signing in..." class="w-full">
            Sign in
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    form = to_form(%{}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
