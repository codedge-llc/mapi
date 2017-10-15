defmodule Mapi.Response do
  @callback content_type :: String.t
  @callback format_result(any) :: any
end
