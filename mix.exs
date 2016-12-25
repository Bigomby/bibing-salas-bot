defmodule BibingSalasBot.Mixfile do
  use Mix.Project

  def project do
    [app: :bibing_salas_bot,
     version: "0.1.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [
       "coveralls": :test,
       "coveralls.detail": :test,
       "coveralls.post": :test,
       "coveralls.html": :test
     ],
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.9"},
      {:poison, "~> 2.2"},
      {:mock, "~> 0.2.0", only: :test},
      {:excoveralls, "~> 0.5", only: :test},
      {:credo, "<= 0.5.0", only: [:dev, :test]}
    ]
  end
end
