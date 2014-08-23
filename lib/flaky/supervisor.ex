defmodule Flaky.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      # Define workers and child supervisors to be supervised
      worker(Flaky.Server, [])
    ]

    supervise children, strategy: :one_for_one
  end
end
