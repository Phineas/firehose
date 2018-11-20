defmodule FirehoseTest do
  use ExUnit.Case
  doctest Firehose

  test "greets the world" do
    assert Firehose.hello() == :world
  end
end
