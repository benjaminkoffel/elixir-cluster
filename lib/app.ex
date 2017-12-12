defmodule App do
  use Application

  def start(_type, _args) do
    connect()
    App.Supervisor.start_link(name: App.Supervisor)
  end

  # ping nodes in hosts.txt to connect to cluster
  def connect() do
    File.stream!(".hosts.txt") 
    |> Stream.map(&String.trim/1) 
    |> Stream.map(&String.to_atom/1) 
    |> Stream.map(&Node.connect/1) 
    |> Stream.run
  end

  # kick off some random job to burn cpu
  def work(name) do
    {:ok, pid} = Swarm.register_name(name, App.Supervisor, :register, [name])
    Swarm.join(:group, pid)
  end
end
