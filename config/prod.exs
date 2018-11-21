config :sse,
  keep_alive: {:system, "SSE_KEEP_ALIVE_IN_MS", 30000} # Keep alive in milliseconds

config :event_bus,
  topics: [:redis_cx_updates]

config :libcluster,
  topologies: [
    firehose: [
      strategy: Cluster.Strategy.Kubernetes,
      config: [
        # mode: :dns,
        kubernetes_node_basename: "firehose",
        kubernetes_selector: "app=firehose",
        polling_interval: 10_000,
      ]
    ]
  ]
