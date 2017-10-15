defmodule Mapi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  defp worker_mapper({mod, opts}) do
    id = :erlang.make_ref
    port = Keyword.get(opts, :port, 4000)
    mapi_opts = mapi_opts(mod, opts)
    Plug.Adapters.Cowboy.child_spec(:http, Mapi, mapi_opts, [ref: id, port: port])
  end

  def mapi_opts(mod, opts) do
    opts
    |> Keyword.put(:type, resp_for(opts[:type]))
    |> Keyword.put(:mod, mod)
  end

  defp resp_for(:text), do: Mapi.Response.Plain
  defp resp_for(:json), do: Mapi.Response.Json
  defp resp_for(:etf), do: Mapi.Response.Etf
  defp resp_for(_), do: Mapi.Response.Plain

  def start(_type, _args) do
    workers =
      :mapi
      |> Application.get_env(:endpoints, [])
      |> Enum.map(&worker_mapper/1)

    opts = [strategy: :one_for_one, name: Mapi.Supervisor]
    Supervisor.start_link(workers, opts)
  end
end
