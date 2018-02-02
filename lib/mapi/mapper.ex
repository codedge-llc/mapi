defmodule Mapi.Mapper do
  require Logger

  alias Plug.Conn

  @doc false
  def init(opts) do
    port = Keyword.get(opts, :port, 4000)
    mod = Keyword.get(opts, :mod)
    type = Keyword.get(opts, :type, Mapi.Response.Plain)
    mod |> info(type, port) |> Logger.debug()

    opts
  end

  @doc false
  def call(conn, opts) do
    # Make sure function atoms defined before path conversion
    opts[:mod].__info__(:functions)

    path =
      conn.path_info
      |> List.first()
      |> :erlang.binary_to_existing_atom(:utf8)

    params =
      Conn.fetch_query_params(conn).query_params
      |> Map.values()

    result = apply(opts[:mod], path, params)
    resp_result(conn, result, opts)
  rescue
    ArgumentError ->
      resp_not_found(conn, opts)

    UndefinedFunctionError ->
      resp_bad_request(conn, opts)

    exception ->
      exception |> inspect() |> Logger.error()
      resp_internal_server_error(conn, opts)
  end

  defp resp_result(conn, result, opts) do
    resp = format_result(opts, result)

    conn
    |> Conn.put_resp_content_type(content_type(opts))
    |> Conn.send_resp(200, resp)
  end

  defp resp_not_found(conn, opts) do
    resp = format_result(opts, %{error: :not_found})

    conn
    |> Conn.put_resp_content_type(content_type(opts))
    |> Conn.send_resp(404, resp)
  end

  defp resp_bad_request(conn, opts) do
    resp = format_result(opts, %{error: :bad_request})

    conn
    |> Conn.put_resp_content_type(content_type(opts))
    |> Conn.send_resp(400, resp)
  end

  defp resp_internal_server_error(conn, opts) do
    resp = format_result(opts, %{error: :internal_server_error})

    conn
    |> Conn.put_resp_content_type(content_type(opts))
    |> Conn.send_resp(500, resp)
  end

  defp content_type(opts) do
    Keyword.get(opts, :type, Mapi.Response.Plain).content_type
  end

  defp format_result(opts, result) do
    Keyword.get(opts, :type, Mapi.Response.Plain).format_result(result)
  end

  defp info(mod, type, port) do
    "Running #{mod} server of type #{type} on port #{port}..."
  end
end
