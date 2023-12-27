defmodule BuilderWeb.Plugs.Auth do
  use BuilderWeb, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  alias Builder.Accounts.User

  def auth_fetch_user(conn, _opts) do
    conn = fetch_cookies(conn, signed: ["user"]) 
    user = get_session(conn, "user", User.new())
    conn = put_session(conn, "user", user)
    assign(conn, :user, user)
  end

  def auth_redirect_if_admin(conn, _opts) do
    if User.is_role(conn.assigns[:user], "admin") do
      conn
      |> redirect(to: ~p"/admin")
      |> halt()
    else
      conn
    end
  end

  def auth_redirect_if_anon(conn, _opts) do
    if User.is_role(conn.assigns[:user], "admin") do
      conn
    else
      conn
      |> put_flash(:error, "You must be admin to access this page.")
      |> redirect(to: ~p"/login")
      |> halt()
    end
  end
end
