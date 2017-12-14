use Mix.Config

config :logger, 
  backends: [:console],
  compile_time_purge_level: :info

config :ex_vmstats,
  namespace: "vm_stats",
  backend: :ex_statsd,
  interval: 3000,
  use_histogram: true,
  sched_time: false

config :ex_statsd,
  host: 127.0.0.1,
  port: 8125,
  namespace: "elixir-cluster",
  tags: []
