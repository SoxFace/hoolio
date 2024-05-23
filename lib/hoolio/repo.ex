defmodule Hoolio.Repo do
  use Ecto.Repo,
    otp_app: :hoolio,
    adapter: Ecto.Adapters.Postgres
end
