defmodule App do
  use Application

  def start(_type, _args) do
    App.Supervisor.start_link(name: App.Supervisor)
  end

  def work(name) do
    {:ok, pid} = Swarm.register_name(name, App.Supervisor, :register, [name])
    Swarm.join(:group, pid)
  end
end
