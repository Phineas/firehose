defmodule Firehose.Hose do
  import Plug.Conn
  use Plug.Router

  @topic :redis_cx_updates

  plug :match
  plug :dispatch

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{success: true}))
  end

  get "/pipe" do
    rates = %{test: Firehose.RedisEventBus.fetch()}
    chunk = %SSE.Chunk{data: Poison.encode!(rates)}

    conn
    |> put_resp_header("Access-Control-Allow-Origin", "*")
    |> SSE.stream({[@topic], chunk})
  end

  get "/infra/nodes" do
    nodes = Node.list
    json = %{success: true, nodes: nodes}
    |> Poison.encode!

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, json)
  end
  
  match _ do
    conn
    |> send_resp(404, Poison.encode!(%{success: false, error: "no_match"}))
  end
end
