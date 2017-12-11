# Elixir Cluster

Application to demonstrate cluster using libcluster/swarm for coordinating nodes.

Workers can be spawned and then automatically failed over to surviving nodes.

```
# start iex running app (node names defined in config.exs)
iex --name a@192.168.1.1 -S mix

# open erlang observer
:observer.start

# spawn worker that calculates fibonacci for n then dies
App.fib(n)

# list workers running on this node
Supervisor.which_children(App.Supervisor)
```
