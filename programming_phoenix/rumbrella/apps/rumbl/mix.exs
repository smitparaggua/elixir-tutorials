defmodule Rumbl.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rumbl,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Rumbl.Application, []},
      extra_applications: [:logger, :runtime_tools, :info_sys]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:comeonin, "~> 4.0"},
      {:pbkdf2_elixir, "~> 0.12"},
      {:destructure, "~> 0.2.3"},
      {:info_sys, in_umbrella: true}
    ]
  end

  defp aliases do
    [
      "ecto.setup": [
        "ecto.create", "ecto.migrate", "run priv/repo/seeds.exs",
        "run priv/repo/backend_seeds.exs"
      ],

      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
