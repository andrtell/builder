defmodule Builder.Repo do
  use Ecto.Repo,
    otp_app: :builder,
    adapter: Ecto.Adapters.Postgres
end
