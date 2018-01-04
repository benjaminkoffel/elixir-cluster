defmodule App.Mixfile do
  use Mix.Project

  def project do
    [
      app: :app,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:logger, :swarm, :ex_statsd, :ex_vmstats],
      mod: {App, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:distillery, "~> 1.0"},
      {:swarm, "~> 3.0"},
      {:ex_statsd, "~> 0.5.1"},
      {:ex_vmstats, "~> 0.0.1"}
    ]
  end
end
