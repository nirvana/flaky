defmodule Flaky.Server do

  def start_link do
    Agent.start_link fn -> %{time: time, node: mac_address} end, name: __MODULE__
  end

  def generate(base \\ nil) do
    Agent.get_and_update __MODULE__, &(generate(time, &1, base))
  end

  defp generate(time, %{time: time, node: node, seq: seq}, base) do
    new_state = %{time: time, node: node, seq: (seq+1)}
    {gen_flake(new_state, base), new_state}
  end

  # Matches when the times are different, reset seq
  defp generate(newtime, %{time: time, node: node}, base) when newtime > time do
    new_state = %{time: newtime, node: node, seq: 0}
    {gen_flake(new_state, base), new_state}
  end

  # Error when clock is running backwards
  defp generate(newtime, %{time: time}, _) when newtime < time do
    {:error, :clock_running_backwards}
  end

  defp gen_flake(%{time: time, node: node, seq: seq}, base) do
    flake = <<time::integer-size(64), node::integer-size(48), seq::integer-size(16)>>
    case base do
      nil -> flake
      _ ->
        <<number::integer-size(128)>> = flake
        Flaky.I2l.to_list(number, base)
        |> List.to_string
    end
  end

  def time do
    {mega_seconds, seconds, micro_seconds} = :os.timestamp
    1_000_000_000*mega_seconds + seconds*1_000 + :erlang.trunc(micro_seconds/1_000)
  end

  defp mac_address do
    {:ok, addresses} = :inet.getifaddrs

    {iface, _} =
      Enum.find addresses, fn({_iface, params}) ->
        :broadcast in params[:flags] &&
        :multicast in params[:flags] &&
        params[:hwaddr] &&
        Enum.max(params[:hwaddr]) > 0
      end

    proplist = :proplists.get_value(iface, addresses)
    hwaddr = :proplists.get_value(:hwaddr, proplist)

    <<worker::integer-size(48)>> = :erlang.list_to_binary(hwaddr)
    worker
  end

end
