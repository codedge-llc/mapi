defmodule MapiTest do
  use ExUnit.Case
  doctest Mapi

  test "returns proper function response" do
    resp = HTTPoison.get!("http://localhost:4002/upcase?q1=elixir")
    assert Poison.decode!(resp.body) == "ELIXIR"
    assert resp.status_code == 200
  end

  test "returns 404 if path atom not defined" do
    resp = HTTPoison.get!("http://localhost:4002/not_defined?q1=elixir")
    assert Poison.decode!(resp.body) == %{"error" => "not_found"}
    assert resp.status_code == 404
  end

  test "returns 404 if module's function not defined" do
    _defined = :bogus_fun
    resp = HTTPoison.get!("http://localhost:4002/bogus_fun?q1=elixir")
    assert Poison.decode!(resp.body) == %{"error" => "not_found"}
    assert resp.status_code == 404
  end
end
