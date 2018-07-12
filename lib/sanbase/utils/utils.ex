defmodule Sanbase.Utils do
  defmacro start_only_prod(expr) do
    quote do
      if Mix.exs() == :prod do
        expr
      else
      end
    end
  end
end
