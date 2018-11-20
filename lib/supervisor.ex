defmodule Firehose.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Firehose.Hose, options: [port: 4000]},
      {Firehose.RedisEventBus.start_link}
    ]
    Supervisor.start_link(children, strategy: :one_for_one, name: Firehose.Supervisor)
  end
end