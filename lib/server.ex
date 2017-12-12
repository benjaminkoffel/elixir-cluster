defmodule App.Server do
  require Logger

  # we're going to use name for n
  def start_link(name) do
    Logger.info "App.Server.start_link"
    GenServer.start_link(__MODULE__, name)
  end

  # initialize server and start work
  def init(state) do
    Logger.info "App.Server.init"
    Process.send_after(self(), :work, 100) # kickoff work process
    {:ok, state}
  end

  # swarm: begin handoff
  def handle_call({:swarm, :begin_handoff}, _from, state) do
    Logger.info "App.Server.handle_call :swarm, :begin_handoff #{state}"
    {:reply, {:resume, state}, state}
  end

  # swarm: end handoff
  def handle_cast({:swarm, :end_handoff, state}, _state) do
    Logger.info "App.Server.handle_cast :swarm, :end_handoff #{state}"
    Process.send_after(self(), :work, 100) # restart work process
    {:noreply, state}
  end

  # swarm: resolve conflict
  def handle_cast({:swarm, :resolve_conflict, _state}, state) do
    Logger.info "App.Server.handle_cast :swarm, :resolve_conflict #{state}"
    {:noreply, state}
  end

  # swarm: timeout
  def handle_info(:timeout, state) do
    Logger.info "App.Server.handle_cast :timeout #{state}"
    {:noreply, state}
  end

  # swarm: die
  def handle_info({:swarm, :die}, state) do
    Logger.info "App.Server.handle_cast :swarm :die #{state}"
    {:stop, :shutdown, state}
  end

  # calculate something for value stored in state, then die
  def handle_info(:work, state) do
    Logger.info "App.Server.handle_info :work #{state}"
    # a = fib(1, 1, state)
    a = Enum.join(prime(state), ",")
    # a = Enum.join(n_primes(state), ",")
    Logger.info "App.Server.handle_info :work #{state} #{a}"
    {:stop, :normal, state}
  end

  # calculate fibonacci for n
  def fib(a, b, n) do
    case n do
      0 -> a
      _ -> fib(b, a+b, n-1)
    end
  end

  # calculate n primes
  def is_prime(x) do (2..x |> Enum.filter(fn a -> rem(x, a) == 0 end) |> length()) == 1 end
  def prime(n) do Stream.interval(1) |> Stream.drop(2) |> Stream.filter(&is_prime/1) |> Enum.take(n) end
end
