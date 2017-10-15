defmodule Mapi.Response.Plain do
  @moduledoc false

  @behaviour Mapi.Response

  def content_type, do: "text/plain"

  def format_result(result) do
    inspect(result)
  end
end
