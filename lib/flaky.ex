defmodule Flaky do
  use Application

  def start(_type, _args) do
    Flaky.Supervisor.start_link
  end

  def generate do
    :gen_server.call(:flaky, :generate)
  end

  def generate(base) do
    :gen_server.call(:flaky, {:generate, base})
  end

end
