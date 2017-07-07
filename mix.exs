defmodule Cloudini.Mixfile do
  use Mix.Project

  def project do
    [app: :cloudini,
     version: "1.2.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "Cloudinary client",
     package: package(),
     deps: deps(),
     docs: [extras: ["README.md"]]]
  end

  def application do
    [applications: [:logger, :crypto]]
  end

  defp deps do
    [{:poison, "~> 2.0"},
     {:exvcr, "~> 0.8", only: [:test]}]
  end

  defp package do
    [maintainers: ["Adrian Gruntkowski", "Adam Rutkowski"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/socialpaymentsbv/cloudini"}]
  end
end
