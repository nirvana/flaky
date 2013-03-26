defmodule Flaky.Server do
  use GenServer.Behaviour

  def start_link(state) do
      :gen_server.start_link({ :local, :flaky }, __MODULE__, state, [])
  end

  def init(state) do
    { :ok, state }
  end

  def handle_call(:pop, _from, [h|stack]) do
    { :reply, h, stack }
  end

  def handle_cast({ :push, new }, stack) do
    { :noreply, [new|stack] }
  end
end