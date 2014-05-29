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

	def test do
		# make a base 10 and base 62
		IO.puts " Flake, base 10:" <> :gen_server.call(:flaky, {:generate, 10})
		IO.puts " Flake, base 62:" <> :gen_server.call(:flaky, {:generate, 62})
		# make 100,000 ids, and count how long it takes.
		start = Flaky.Servertime
		results = Enum.map(1..100000, fn(_) -> :gen_server.call(:flaky, {:generate, 62}) end)
		finish = Flaky.Server.time
		IO.puts "Time to generate #{Enum.count results} flakes: #{finish-start} milliseconds."
	end

end
