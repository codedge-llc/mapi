defmodule Mapi do
  require Logger

  def init(opts) do
    port = Keyword.get(opts, :port, 4000)
    mod = Keyword.get(opts, :mod)
    Logger.debug("Running #{mod} server on port #{port}...")

    opts
    |> put_funs(mod)
  end

  defp put_funs(opts, nil), do: opts
  defp put_funs(opts, mod) do
    opts ++ [funs: mod.__info__(:functions)]
  end

  def call(conn, opts) do
    # IO.inspect(conn)
    # IO.inspect(opts)
    path =
      conn.path_info
      |> List.first
      |> String.to_atom
      |> IO.inspect(label: "path")

    params =
      Plug.Conn.fetch_query_params(conn).query_params
      |> Map.values
      |> IO.inspect(label: "params")

    result = apply(opts[:mod], path, params)

    resp =
      result
      |> Poison.encode!

    conn
    |> Plug.Conn.send_resp(200, resp)
  end
end
