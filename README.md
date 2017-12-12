# Elixir Cluster

Application to demonstrate cluster using libcluster/swarm for coordinating nodes.

Workers can be spawned and then automatically failed over to surviving nodes.

```
# set starting nodes in .hosts.txt
echo ":\"a@192.168.1.1\"" > .hosts.txt

# start iex running app
iex --name a@192.168.1.1 -S mix

# spawn worker that calculates n primes then dies
App.work(n)

# list workers running on this node
Supervisor.which_children(App.Supervisor)

# or open erlang observer
:observer.start
```

AWS Resources:
```
elixir-cluster-autoscaling-group
elixir-cluster-launch-configuration
elixir-cluster-key-pair
elixir-cluster-security-group
```

AWS Initialisation:
```
curl -s https://raw.githubusercontent.com/benjaminkoffel/elixir-cluster/master/aws/init.sh | sudo bash
```

References:
https://johnhamelink.com/2016/03/03/elixir-and-ec2
