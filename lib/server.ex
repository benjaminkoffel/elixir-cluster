defmodule App.Server do
  require Logger

  # we're going to use name for n
  def start_link(name) do
    Logger.info "App.Server.start_link"
    GenServer.start_link(__MODULE__, [name, name])
  end

  # initialize server and start work
  def init([name, delay]) do
    Logger.info "App.Server.init"
    Process.send_after(self(), :work, 100) # kickoff work process
    {:ok, {name, delay}, 0}
  end

  # swarm: begin handoff
  def handle_call({:swarm, :begin_handoff}, _from, {name, delay}) do
    Logger.info "App.Server.handle_call :swarm, :begin_handoff #{name}"
    {:reply, {:resume, delay}, {name, delay}}
  end

  # swarm: end handoff
  def handle_cast({:swarm, :end_handoff, delay}, {name, _}) do
    Logger.info "App.Server.handle_cast :swarm, :end_handoff #{name}"
    {:noreply, {name, delay}}
  end

  # swarm: resolve conflict
  def handle_cast({:swarm, :resolve_conflict, _delay}, {name, delay}) do
    Logger.info "App.Server.handle_cast :swarm, :resolve_conflict #{name}"
    {:noreply, {name, delay}}
  end

  # swarm: timeout
  def handle_info(:timeout, {name, delay}) do
    Logger.info "App.Server.handle_cast :timeout #{name}"
    {:noreply, {name, delay}}
  end

  # swarm: die
  def handle_info({:swarm, :die}, {name, delay}) do
    Logger.info "App.Server.handle_cast :swarm :die #{name}"
    {:stop, :shutdown, {name, delay}}
  end

  # calculate something for value stored in state, then die
  def handle_info(:work, {name, delay}) do
    Logger.info "App.Server.handle_info :work #{name}"
    a = Enum.join(prime(delay), ",")
    Logger.info "App.Server.handle_info :work #{name} #{a}"
    {:stop, :normal, {name, delay}}
  end

  # calculate n primes
  def is_prime(x) do (2..x |> Enum.filter(fn a -> rem(x, a) == 0 end) |> length()) == 1 end
  def prime(n) do Stream.interval(1) |> Stream.drop(2) |> Stream.filter(&is_prime/1) |> Enum.take(n) end
end
