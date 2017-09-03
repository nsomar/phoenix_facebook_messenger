defmodule FacebookMessenger.Phoenix.Mixfile do
  use Mix.Project

  def project do
    [
      app: :phoenix_facebook_messenger,
      name: "PhoenixFacebookMessenger",
      source_url: "https://github.com/oarrabi/phoenix_facebook_messenger",
      version: "0.4.0",
      docs: [ extras: ["README.md"] ],
      elixir: "~> 1.0",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      test_coverage: [tool: Coverex.Task, coveralls: true],
      deps: deps(),
      package: package(),
      description: description()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpotion]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    d =
    [{:phoenix, "~> 1.1"},
     {:facebook_messenger, "~> 0.4.0"},
     {:inch_ex, only: :docs},
     {:ex_doc, "~> 0.7", only: :dev},
     {:earmark, "~> 0.1", only: :docs}]

     if Mix.env == :test do
      [{:coverex, "~> 1.4.8", only: :test}, {:poison, "~> 2.1.0", override: true} | d]
    else
      [{:poison, "~> 2.1.0 or ~> 3.0"} | d]
    end
  end

  defp description do
    """
    PhoenixFacebookMessenger is a library that easy the creation of facebook messenger bots.
    """
  end

  defp package do
    [ files: [ "lib", "mix.exs", "README.md",],
      maintainers: [ "Omar Abdelhafith" ],
      licenses: ["MIT"],
      links: %{ "GitHub" => "https://github.com/oarrabi/exrequester" } ]
  end
end
