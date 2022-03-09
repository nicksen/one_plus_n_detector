defmodule OnePlusNDetector.Repo do
  use Ecto.Repo,
    otp_app: :one_plus_n_detector,
    adapter: Ecto.Adapters.Postgres
end
