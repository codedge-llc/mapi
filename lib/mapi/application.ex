defmodule Mapi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  defp worker_mapper({mod, opts}) do
    id = Module.concat(Mapi, mod)
    port = Keyword.get(opts, :port, 4000)
    Plug.Adapters.Cowboy.child_spec(:http, Mapi, [mod: mod, port: port], [ref: id, port: port])
  end

  def start(_type, _args) do
    workers =
      :mapi
      |> Application.get_env(:endpoints, [])
      |> Enum.map(&worker_mapper/1)

    opts = [strategy: :one_for_one, name: Mapi.Supervisor]
    Supervisor.start_link(workers, opts)
  end
end
