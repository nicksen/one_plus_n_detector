defmodule OnePlusNDetector.MixProject do
  use Mix.Project

  def project do
    [
      app: :one_plus_n_detector,
      deps: deps(),
      description: description(),
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      start_permanent: Mix.env() == :prod,
      version: "0.1.1"
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {OnePlusNDetector, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ecto, "~> 3.0"},
      {:ex_doc, ">= 0.0.0", only: [:dev]},
      {:ecto_sql, "~> 3.0", only: [:test]},
      {:postgrex, ">= 0.0.0", only: [:test]}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/san650/one_plus_n_detector"},
      maintainers: ["Santiago Ferreira"],
      name: :one_plus_n_detector
    ]
  end

  defp description do
    """
    Detect 1+n SQL queries in your Ecto application.
    """
  end
end
