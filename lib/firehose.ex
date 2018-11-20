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
end