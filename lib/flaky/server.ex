defmodule Flaky.Server do
  use GenServer.Behaviour

  def start_link(state) do
      :gen_server.start_link({ :local, :flaky }, __MODULE__, state, [])
  end

  def init(state) do
    { :ok, state }
  end


#defrecord FlakyState, node: nil, time: 0, sq: 0

  def handle_call(:get, _from, state) do
    { flake, new_state} = get(Flake.time, state, 10)
    { :reply, flake, new_state }
  end

  def handle_call({:get, base}, _from, state) do
    { flake, new_state} = get(Flake.time, state, base)
    { :reply, flake, new_state }
  end


  # Matches when the calling time is the same as the state time. Incr. sq
  def get(time, FlakyState[time: time, node: node, sq: seq], base) do
    IO.puts "Matches when the calling time is the same as the state time. Incr. sq"
    IO.puts "Making new state"
    new_state = FlakyState.new(time: time, node: node, sq: (seq+1))
    IO.puts "Generating flake"
    {gen_flake(new_state, base), new_state}
  end

  # Matches when the times are different, reset sq
  def get(newtime, FlakyState[time: time, node: node, sq: seq], base)  when newtime > time do
    IO.puts "Matches when the times are different, reset sq"
    new_state = FlakyState.new(time: newtime, node: node, sq: 0)
    IO.puts "Generating flake"
    {gen_flake(new_state, base), new_state}
  end 

  # Error when clock is running backwards
  def get(newtime, FlakyState[time: time, node: node, sq: seq], base) when newtime < time do
    {:error, :clock_running_backwards}
  end

  def gen_flake(FlakyState[time: time, node: node, sq: seq], base) do
    IO.puts "Flake: time: #{time} node: #{node} seq: #{seq}"
    <<number::[integer, size(128)]>> = <<time::[integer, size(64)],node::[integer, size(48)],seq::[integer, size(16)]>>
    IO.puts "Have a flake."
    list_to_binary(integer_to_list(number, base))
  end

def handle_cast({ :push, new }, stack) do
    { :noreply, [new|stack] }
  end

end