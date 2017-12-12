defmodule App do
  use Application

  def start(_type, _args) do
    connect()
    App.Supervisor.start_link(name: App.Supervisor)
  end

  # ping nodes in hosts.txt to connect to cluster
  defp connect() do
    File.open!(".hosts.txt")
    |> IO.stream(:line)
    |> Enum.each(&Node.ping(String.to_atom(String.trim(&1))))
  end

  # kick off some random job to burn cpu
  def work(name) do
    {:ok, pid} = Swarm.register_name(name, App.Supervisor, :register, [name])
    Swarm.join(:group, pid)
  end
end
