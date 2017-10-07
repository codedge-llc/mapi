defmodule MapiTest do
  use ExUnit.Case
  doctest Mapi

  describe "Elixir.String endpoint" do
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

  describe "Mapi.TestModule endpoint" do
    test "test_fun/0 returns proper function response" do
      resp = HTTPoison.get!("http://localhost:4003/test_fun")
      assert Poison.decode!(resp.body) == %{"success" => true}
      assert resp.status_code == 200
    end

    test "test_fun/1 returns proper function response" do
      resp = HTTPoison.get!("http://localhost:4003/test_fun?q1=whatever")
      assert Poison.decode!(resp.body) == %{
        "success" => true,
        "param" => "whatever"
      }
      assert resp.status_code == 200
    end
  end
end
