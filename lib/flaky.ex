defmodule Flaky do

  def start(_type, _args) do
    Flaky.Supervisor.start_link
  end

  def generate do
    :gen_server.call(:flaky, :generate)
  end

  def generate(base) do
    :gen_server.call(:flaky, {:generate, base})
  end

	def numeric do
 		:gen_server.call(:flaky, {:generate, 10})
	end

	def alpha do
		:gen_server.call(:flaky, {:generate, 62})
	end

end
