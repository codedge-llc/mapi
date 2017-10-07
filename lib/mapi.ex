defmodule Mapi do
  require Logger

  def init(opts) do
    port = Keyword.get(opts, :port, 4000)
    mod = Keyword.get(opts, :mod)
    Logger.debug(info(mod, port))

    opts
  end

  defp info(mod, port) do
    "Running #{mod} server on port #{port}..."
  end

  def call(conn, opts) do
    mod = opts[:mod]
    try do
      path =
        conn.path_info
        |> List.first
        |> String.to_charlist
        |> List.to_existing_atom

      params =
        Plug.Conn.fetch_query_params(conn).query_params
        |> Map.values

      if Kernel.function_exported?(mod, path, Enum.count(params)) do
        resp =
          opts[:mod]
          |> apply(path, params)
          |> Poison.encode!

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(200, resp)
      else
        resp_not_found(conn)
      end
    rescue
      _exception -> resp_not_found(conn)
    end
  end

  defp resp_not_found(conn) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(404, Poison.encode!(%{error: :not_found}))
  end
end
