use Mix.Config

config :logger, 
  backends: [:console],
  compile_time_purge_level: :info

config :libcluster,
  topologies: [
    app: [
      strategy: Cluster.Strategy.ErlangHosts
    ]
  ]

# config :libcluster,
#   topologies: [
#     app: [
#       strategy: Cluster.Strategy.Epmd,
#       config: [
#         hosts: [
#           :"a@172.19.185.194", 
#           :"b@172.19.185.194"
#         ]
#       ],
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
