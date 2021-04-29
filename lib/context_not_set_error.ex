defmodule ExCrud.ContextNotSetError do
  @moduledoc false

  defexception message: "expected context to be set"
end
