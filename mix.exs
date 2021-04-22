defmodule ExCrud.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_crud,
      version: "0.1.0",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      elixirc_options: [warnings_as_errors: true],
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      # Documentation
      name: "ExTenant",
      source_url: project_url(),
      homepage_url: project_url(),
      docs: [
        # The main page in the docs
        main: "ExTenant",
        extras: ["README.md"]
      ]
    ]
  end

  defp project_url, do: "https://github.com/elixir-garage/ex_crud"

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Elixirgarage"],
      licenses: ["Apache License 2.0"],
      links: %{"GitHub" => "https://github.com/elixir-garage/ex_crud"}
    ]
  end

  defp description do
    """
      Macro based code generator for Elixir Phoenix contexts - generating CRUD ecto functions
      to DRY up the code base
    """
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.5"},
      {:postgrex, "~> 0.15.8", only: :test},
      {:ecto_sql, "~> 3.5", only: :test},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end
end
