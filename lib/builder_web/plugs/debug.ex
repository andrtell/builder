defmodule BuilderWeb.Plugs.Debug do
  def debug(conn, _opts) do
    dbg conn
  end
end
