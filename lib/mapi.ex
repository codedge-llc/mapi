defmodule Mapi do
  use Plug.Builder

  plug(CORSPlug)
  plug(Mapi.Mapper)

  def init(opts) do
    {CORSPlug.init(opts), Mapi.Mapper.init(opts)}
  end

  def call(conn, {opts1, opts2}) do
    case CORSPlug.call(conn, opts1) do
      %Plug.Conn{halted: true} = conn -> conn
      conn -> Mapi.Mapper.call(conn, opts2)
    end
  end

  @doc ~S"""
  Starts a Mapi server with given opts.

  ## Examples

      iex> {:ok, ref} = Mapi.start(String, [port: 8000])
      iex> is_reference(ref)
      true
      iex> Mapi.start(Enum, [port: 8000])
      {:error, :eaddrinuse}
  """
  @spec start(module, Keyword.t()) ::
          {:ok, reference}
          | {:error, :eaddrinuse}
          | {:error, term}
  def start(mod, opts) do
    id = :erlang.make_ref()
    port = Keyword.get(opts, :port, 4000)
    mapi_opts = Mapi.Application.mapi_opts(mod, opts)

    case Plug.Adapters.Cowboy2.http(Mapi, mapi_opts, ref: id, port: port) do
      {:ok, _pid} -> {:ok, id}
      error -> error
    end
  end

  @doc ~S"""
  Stops a running Mapi server.

  ## Examples

      iex> {:ok, ref} = Mapi.start(String, [port: 8001])
      iex> Mapi.stop(ref)
      :ok
  """
  @spec stop(reference) :: :ok
  def stop(ref) do
    Plug.Adapters.Cowboy2.shutdown(ref)
  end
end
