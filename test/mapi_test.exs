defmodule MapiTest do
  use ExUnit.Case
  doctest Mapi

  describe "Elixir.String endpoint" do
    setup do
      port = Enum.random(4000..7000)
      {:ok, pid} = Mapi.start(String, port: port, type: :json)

      on_exit(fn ->
        Mapi.stop(pid)
      end)

      {:ok, %{port: port}}
    end

    test "returns proper function response", %{port: port} do
      resp = HTTPoison.get!("http://localhost:#{port}/upcase?q1=elixir")
      assert Poison.decode!(resp.body) == "ELIXIR"
      assert resp.status_code == 200
    end

    test "returns 404 if path atom not defined", %{port: port} do
      resp = HTTPoison.get!("http://localhost:#{port}/not_defined?q1=elixir")
      assert Poison.decode!(resp.body) == %{"error" => "not_found"}
      assert resp.status_code == 404
    end

    test "returns 400 if module's function not defined", %{port: port} do
      _defined = :bogus_fun
      resp = HTTPoison.get!("http://localhost:#{port}/bogus_fun?q1=elixir")
      assert Poison.decode!(resp.body) == %{"error" => "bad_request"}
      assert resp.status_code == 400
    end

    test "returns 500 for misc errors", %{port: port} do
      resp = HTTPoison.get!("http://localhost:#{port}/at?q1=elixir&q2=bad")
      assert Poison.decode!(resp.body) == %{"error" => "internal_server_error"}
      assert resp.status_code == 500
    end
  end

  describe "Mapi.TestModule endpoint" do
    setup do
      port = Enum.random(4000..7000)
      {:ok, pid} = Mapi.start(Mapi.TestModule, port: port, type: :json)

      on_exit(fn ->
        Mapi.stop(pid)
      end)

      {:ok, %{port: port}}
    end

    test "test_fun/0 returns proper function response", %{port: port} do
      resp = HTTPoison.get!("http://localhost:#{port}/test_fun")
      assert Poison.decode!(resp.body) == %{"success" => true}
      assert resp.status_code == 200
    end

    test "test_fun/1 returns proper function response", %{port: port} do
      resp = HTTPoison.get!("http://localhost:#{port}/test_fun?q1=whatever")

      assert Poison.decode!(resp.body) == %{
               "success" => true,
               "param" => "whatever"
             }

      assert resp.status_code == 200
    end
  end
end
