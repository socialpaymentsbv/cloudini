defmodule Cloudini.Mixfile do
  use Mix.Project

  def project do
    [app: :cloudini,
     version: "1.0.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "Cloudinary client",
     package: package,
     deps: deps,
     docs: [extras: ["README.md"]]]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :crypto, :quintana]]
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
    [{:poison, "~> 2.0"},
     {:quintana, "~> 0.2.1"},
     {:exvcr, "~> 0.7.4", only: [:dev, :test]}]
  end

  defp package do
    [maintainers: ["Adrian Gruntkowski", "Adam Rutkowski"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/socialpaymentsbv/cloudini"}]
  end
end
