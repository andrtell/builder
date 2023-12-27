defmodule BuilderWeb.UserSessionController do
  use BuilderWeb, :controller

  alias Builder.Accounts.User

  import Plug.Conn
  import Phoenix.Controller

  def create(conn, %{"user" => user_params}) do
    %{"password" => password} = user_params

    admin_password = Application.get_env(:builder, :admin_password)

    if password == admin_password do
      conn 
      |> renew_session()
      |> put_session(:user, User.new() |> User.set_role("admin"))
      |> put_session(:live_socket_id, "socket:admin")
      |> redirect(to: ~p"/admin")
    else
      conn 
      |> put_flash(:error, "Bad password") 
      |> redirect(to: ~p"/login")
    end
  end

  def delete(conn, _params) do
    if live_socket_id = get_session(conn, :live_socket_id) do
      BuilderWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> redirect(to: ~p"/")
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end
end
