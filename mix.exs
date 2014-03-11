defmodule Flaky.Mixfile do
  use Mix.Project

  def project do
    [ app: :flaky,
      version: "0.0.1",
      deps: deps ]
  end

  # Note: This configuration presumes you have an ethernet device named 'en0'
  # you will want to update this with your correct ethernet device name.
  # Feel free to add exconfig as a dependency and make this read the device from a config file.
  
  # Configuration for the OTP application
  def application do
    [
    	registered: [:flaky], 
    	mod: { Flaky, 'en0' },
     	applications: []
 	]
  end




  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    []
  end
end
