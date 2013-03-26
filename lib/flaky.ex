defrecord FlakyState, node: nil, time: 0

defmodule Flaky do
	use Application.Behaviour

	# See http://elixir-lang.org/docs/stable/Application.Behaviour.html
	# for more information on OTP Applications
	def start(_type, device) do
		#Need FlakeState to startup.  State needs the MAC address & current time
		state = FlakyState.new(time: Flaky.time, node:Flaky.mac(device))
		Flaky.Supervisor.start_link(state)
	end

	def time do
		{mega_seconds, seconds, micro_seconds} = :erlang.now()
		1000000000*mega_seconds + seconds*1000 + :erlang.trunc(micro_seconds/1000)
	end

	def mac(name) do
		{:ok, addresses} = :inet.getifaddrs()
		proplist = :proplists.get_value(name, addresses)
		case proplist do
			:undefined -> {:error, :interface_not_found}
			_ -> :proplists.get_value(:hwaddr, proplist)
		end
	end


end
