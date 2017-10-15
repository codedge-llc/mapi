defmodule Mapi.Response.Json do
  @moduledoc false

  @behaviour Mapi.Response

  def content_type, do: "application/json"

  def format_result(result) do
    Poison.encode!(result)
  end
end
