defmodule Livewave.Repo do
  use Ecto.Repo,
    otp_app: :livewave,
    adapter: Ecto.Adapters.Postgres
end
