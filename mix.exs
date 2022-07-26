defmodule Airports.MixProject do
  use Mix.Project

  def project do
    [
      app: :airports,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger,:remix]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      {:flow, "~> 1.2" },
      {:nimble_csv, "~> 1.2"},
      {:benchee,"~> 1.1.0 "},
      {:remix, "~> 0.0.2",only: :dev}
    ]
  end
end
