defmodule App.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
        worker(App.Server, [], restart: :temporary)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

  def register(name) do
    {:ok, _pid} = Supervisor.start_child(__MODULE__, [name])
  end
end
