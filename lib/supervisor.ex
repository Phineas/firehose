defmodule Firehose.Application do
  use Application

  def start(_type, _args) do
    Firehose.RedisEventBus.start_link

    children = [
      {Plug.Cowboy, scheme: :http, plug: Firehose.Hose, options: [port: 8080]}
    ]
    Supervisor.start_link(children, strategy: :one_for_one, name: Firehose.Supervisor)
  end
end
