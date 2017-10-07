defmodule Mapi.TestModule do
  def test_fun do
    %{success: true}
  end

  def test_fun(param) do
    %{success: true, param: param}
  end
end
