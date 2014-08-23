defmodule Flaky.Server do
  use GenServer.Behaviour

  def start_link do
    :gen_server.start_link({ :local, :flaky }, __MODULE__, [], [])
  end

  def init(_opts) do
    {:ok, %{time: time, node: mac_address}}
  end

  def handle_call(:generate, _from, state) do
    {flake, new_state} = generate(time, state)
    {:reply, flake, new_state}
  end

  def handle_call({:generate, base}, _from, state) do
    {flake, new_state} = generate(time, state, base)
    {:reply, flake, new_state}
  end

  def generate(time, %{time: time, node: node, seq: seq}, base \\ nil) do
    new_state = %{time: time, node: node, seq: (seq+1)}
    {gen_flake(new_state, base), new_state}
  end

  # Matches when the times are different, reset seq
  def generate(newtime, %{time: time, node: node}, base) when newtime > time do
    new_state = %{time: newtime, node: node, seq: 0}
    {gen_flake(new_state, base), new_state}
  end

  # Error when clock is running backwards
  def generate(newtime, %{time: time}, _) when newtime < time do
    {:error, :clock_running_backwards}
  end

  def gen_flake(%{time: time, node: node, seq: seq}, base) do
    flake = <<time::[integer, size(64)],node::[integer, size(48)],seq::[integer, size(16)]>>
    if nil?(base) do
      flake
    else
      <<number::[integer, size(128)]>> = flake
      nlist = Flaky.I2l.to_list(number, base)
      :erlang.list_to_binary(nlist)
    end
  end

  def handle_cast({ :push, new }, stack) do
    { :noreply, [new|stack] }
  end

  defp time do
    {mega_seconds, seconds, micro_seconds} = :os.timestamp
    1000000000*mega_seconds + seconds*1000 + :erlang.trunc(micro_seconds/1000)
  end

  defp mac_address do
    {:ok, addresses} = :inet.getifaddrs

    {iface, _} =
      Enum.find addresses, fn({_iface, params}) ->
        if Enum.member?(params[:flags], :broadcast) and Enum.member?(params[:flags], :multicast) do
          not nil?(params[:hwaddr]) and Enum.max(params[:hwaddr]) > 0
        end
      end

    proplist = :proplists.get_value(iface, addresses)
    hwaddr = :proplists.get_value(:hwaddr, proplist)

    <<worker::[integer, size(48)]>> = :erlang.list_to_binary(hwaddr)
    worker
  end

end