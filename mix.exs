defmodule Mapi.Mixfile do
  use Mix.Project

  @version "0.3.0"

  def project do
    [
      app: :mapi,
      name: "mapi",
      description: description(),
      package: package(),
      version: @version,
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      docs: [
        main: "readme",
        extras: [
          "README.md"
        ]
      ],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      dialyzer: [
        plt_add_apps: [:poison]
      ],
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp description do
    "Turn your Elixir module into an HTTP/2 microservice API"
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Mapi.Application, []}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 2.1"},
      {:plug, "~> 1.5.0-rc.1"},
      {:poison, "~> 3.0"},
      {:httpoison, "~> 0.13.0", only: :test},
      {:earmark, "~> 1.0", only: :dev},
      {:ex_doc, "~> 0.2", only: :dev},
      {:excoveralls, "~> 0.5", only: :test},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Henry Popp"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/codedge-llc/mapi"}
    ]
  end
end
