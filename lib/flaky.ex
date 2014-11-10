defmodule Flaky do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Flaky.Server, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Flaky.Supervisor]
    Supervisor.start_link(children, opts)
  end


  def generate(base) do
    Flaky.Server.generate(base)
  end

	def numeric do
    Flaky.Server.generate(10)
	end

	def alpha do
    Flaky.Server.generate(62)
	end

end
