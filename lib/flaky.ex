
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
		Flaky.Supervisor.start_link(state)
	end

	def time do
		{mega_seconds, seconds, micro_seconds} = :erlang.now()
		1000000000*mega_seconds + seconds*1000 + :erlang.trunc(micro_seconds/1000)
	end

	def mac(name) do
		IO.puts "getting node id"
		{:ok, addresses} = :inet.getifaddrs()
		proplist = :proplists.get_value(name, addresses)
		hwaddr = :proplists.get_value(:hwaddr, proplist)
		<<worker::[integer, size(48)]>> = list_to_binary(hwaddr)
		IO.puts "worker is: #{worker}"
		worker
	end
# hw_addr_to_int(HwAddr) ->
#    <<WorkerId:48/integer>> = erlang:list_to_binary(HwAddr),
#    WorkerId.


end
