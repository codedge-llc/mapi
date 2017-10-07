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
        result = apply(opts[:mod], path, params)

        resp =
          result
          |> Poison.encode!

        status = status_for_result(result)
        conn
        |> Plug.Conn.send_resp(status, resp)
      else
        resp_not_found(conn)
      end
    rescue
      _exception -> resp_not_found(conn)
    end
  end

  defp resp_not_found(conn) do
    conn
    |> Plug.Conn.send_resp(404, "Not found.")
  end

  defp status_for_result({:error, _}), do: 400
  defp status_for_result(_), do: 200
end
