defmodule Flaky do
  use Application

  def start(_type, _args) do
    Flaky.Supervisor.start_link
  end

  def generate(base) do
    Flaky.Server.generate(base)
  end

end
