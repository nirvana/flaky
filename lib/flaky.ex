defmodule Flaky do

  def start(_type, _args) do
    Flaky.Supervisor.start_link
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
