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
      applications: [:logger, :libcluster, :swarm],
      mod: {App, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:distillery, "~> 1.0"},
      {:libcluster, "~> 2.1"},
      {:swarm, "~> 3.0"}
      # {:manifold, "~> 1.0"}
    ]
  end
end
