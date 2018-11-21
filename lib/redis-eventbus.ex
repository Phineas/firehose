defmodule Firehose.RedisEventBus do
  use GenServer
  @topic :redis_cx_updates

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def fetch do
    GenServer.call(__MODULE__, {:fetch})
  end

  def init(_) do
    IO.puts "R-init"
    channel = "test"

    {:ok, conn} = Redix.PubSub.start_link(host: "localhost", port: 6379)
    Redix.PubSub.subscribe(conn, channel, self())

    {:ok, :no_state}
  end

  def handle_info({:redix_pubsub, _pubsub, _pid, :subscribed, %{channel: channel}}, state) do
    IO.puts "Redis: subscribed to #{channel}"
    {:noreply, state}
  end

  def handle_info({:redix_pubsub, _pubsub, _pid, :unsubscribed, %{channel: channel}}, state) do
    IO.puts "Redis: unsubscribed from #{channel}"
    {:noreply, state}
  end

  def handle_info({:redix_pubsub, _pubsub, _pid, :message, %{payload: payload}}, state) do
    IO.puts "Redis: received message #{payload}"
    msg = %{message: payload}
    chunk = %SSE.Chunk{data: Poison.encode!(msg)}
    EventBus.notify(%EventBus.Model.Event{id: 1, data: chunk, topic: :redis_cx_updates})
    {:noreply, state}
  end

  def handle_call({:fetch}, _from, state) do
    {:reply, state, state}
  end
end
