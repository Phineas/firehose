defmodule Firehose.MixProject do
  use Mix.Project

  def project do
    [
      app: :firehose,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Firehose.Application, []},
      extra_applications: [:logger, :libcluster, :httpoison]
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:sse, "~> 0.2"},
      {:event_bus, ">= 1.6.0"},
      {:poison, "~> 3.1"},
      {:redix_pubsub, ">= 0.5.0"},
      {:libcluster, "~> 3.0.3"},
      {:distillery, "~> 2.0"},
      {:joken, "~> 2.0"},
      {:httpoison, "~> 1.4"},
    ]
  end
end
