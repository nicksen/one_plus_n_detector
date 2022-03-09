defmodule OnePlusNDetector do
  use Application
  use OnePlusNDetector.ConfigUtils, otp_app: :one_plus_n_detector

  @moduledoc """
  Ecto Repo's logger adapter.

      config :my_app, MyApp.Repo, loggers: [
        {Ecto.LogEntry, :log, []}, # default adapter
        {OnePlusNDetector, :analyze, []}
      ]
  """

  @impl Application
  def start(_type, _args) do
    Supervisor.start_link(children(), strategy: :one_for_one)
  end

  defp children do
    env_specific!(
      test: [
        OnePlusNDetector.Repo,
        OnePlusNDetector.ReadReplica,
        OnePlusNDetector.Detector
      ],
      else: [
        OnePlusNDetector.Detector
      ]
    )
  end
end
