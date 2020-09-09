defmodule Raijin.Repo do
  use Ecto.Repo,
    otp_app: :raijin,
    adapter: Ecto.Adapters.Postgres
end
