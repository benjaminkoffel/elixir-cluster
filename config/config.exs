use Mix.Config

config :logger, 
  backends: [:console],
  compile_time_purge_level: :info

# config :libcluster,
#   topologies: [
#     app: [
#       strategy: Cluster.Strategy.ErlangHosts
#     ]
#   ]

# config :libcluster,
#   topologies: [
#     app: [
#       strategy: Cluster.Strategy.Epmd,
#       config: [
#         hosts: [
#           :"ip-172-31-31-153@172.31.31.153", 
#           :"ip-172-31-11-52@172.31.11.52"
#         ]
#       ]
#     ]
#   ]

# config :libcluster,
#   topologies: [
#     gossip_example: [
#       strategy: Cluster.Strategy.Gossip,
#       config: [
#         port: 45892,
#         if_addr: {0,0,0,0},
#         multicast_addr: {230,1,1,251},
#         multicast_ttl: 1
#       ]
#     ]
#   ]
