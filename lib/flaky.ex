# Node is the id of this node (based on MAC address)
# Time is the stateful time (to tell if we're called more than once during time resolution period)
# SQ is the sequence number which is incremented so that multiple calls in a time slice will generate unique ids.
defrecord FlakyState, node: nil, time: 0, sq: 0

defmodule Flaky do
	use Application.Behaviour

	# See http://elixir-lang.org/docs/stable/Application.Behaviour.html
	# for more information on OTP Applications
	def start(_type, device) do
		#Need FlakeState to startup.  State needs the MAC address & current time
		state = FlakyState.new(time: Flaky.time, node: Flaky.mac(device))
		IO.puts "Flaky.start - worker/node id is: #{state.node}"
		Flaky.Supervisor.start_link(state)
	end

	def time do
		{mega_seconds, seconds, micro_seconds} = :os.timestamp()
		1000000000*mega_seconds + seconds*1000 + :erlang.trunc(micro_seconds/1000)
	end

	def mac(name) do
		{:ok, addresses} = :inet.getifaddrs()
		proplist = :proplists.get_value(name, addresses)
		hwaddr = :proplists.get_value(:hwaddr, proplist)
		<<worker::[integer, size(48)]>> = :erlang.list_to_binary(hwaddr)
		worker
	end
# hw_addr_to_int(HwAddr) ->
#    <<WorkerId:48/integer>> = erlang:list_to_binary(HwAddr),
#    WorkerId.

	def test do
		# make a base 10 and base 62
		IO.puts " Flake, base 10:" <> :gen_server.call(:flaky, :get)
		IO.puts " Flake, base 62:" <> :gen_server.call(:flaky, {:get, 62})
		# make 100,000 ids, and count how long it takes.
		start = Flaky.time
		results = Enum.map(1..100000, fn(_) -> :gen_server.call(:flaky, {:get, 62}) end)
		finish = Flaky.time
		IO.puts "Time to generate #{Enum.count results} flakes: #{finish-start} milliseconds."
	end


end
