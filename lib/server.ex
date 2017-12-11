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

  # calculate fibonacci for value stored in state, then die
  def handle_info(:work, state) do
    Logger.info "App.Server.handle_info :work #{state}"
    f = fib(1, 1, state)
    Logger.info "App.Server.handle_info :work #{state} #{f}"
    {:stop, :normal, state}
  end

  # pretty ordinary fibonacci function
  def fib(a, b, n) do
    case n do
      0 -> a
      _ -> fib(b, a+b, n-1)
    end
  end
end
