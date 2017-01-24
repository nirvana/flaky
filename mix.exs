defmodule Flaky.Mixfile do
  use Mix.Project

  def project do
    [ app: :flaky,
      version: "0.0.6",
      elixir: "~> 1.3.0",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      applications: [],
      mod: { Flaky, [] }
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    []
  end
end
