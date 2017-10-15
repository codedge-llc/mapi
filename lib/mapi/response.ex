defmodule Mapi.Response do
  @moduledoc false

  @callback content_type :: String.t
  @callback format_result(any) :: any
end
