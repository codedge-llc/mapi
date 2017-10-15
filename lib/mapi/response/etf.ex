defmodule Mapi.Response.Etf do
  @behaviour Mapi.Response

  def content_type, do: "application/octet-stream"

  def format_result(result) do
    :erlang.term_to_binary(result)
  end
end
