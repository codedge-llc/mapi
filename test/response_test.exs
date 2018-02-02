defmodule Mapi.ResponseTest do
  use ExUnit.Case

  test "Plaintext response returns proper format" do
    port = Enum.random(4000..7000)
    {:ok, pid} = Mapi.start(String, port: port, type: :text)

    resp = HTTPoison.get!("http://localhost:#{port}/upcase?q1=elixir")
    assert resp.status_code == 200
    assert resp.body == ~s("ELIXIR")

    Mapi.stop(pid)
  end

  test "JSON response returns proper format" do
    port = Enum.random(4000..7000)
    {:ok, pid} = Mapi.start(String, port: port, type: :json)

    resp = HTTPoison.get!("http://localhost:#{port}/upcase?q1=elixir")
    assert Poison.decode!(resp.body) == "ELIXIR"
    assert resp.status_code == 200

    Mapi.stop(pid)
  end

  test "ETF response returns proper format" do
    port = Enum.random(4000..7000)
    {:ok, pid} = Mapi.start(String, port: port, type: :etf)

    resp = HTTPoison.get!("http://localhost:#{port}/upcase?q1=elixir")
    assert resp.status_code == 200
    assert resp.body == :erlang.term_to_binary("ELIXIR")

    Mapi.stop(pid)
  end
end
