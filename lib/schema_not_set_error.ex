defmodule ExCrud.SchemaNotSetError do
  @moduledoc false

  defexception message: "expected schema_module to be set"
end
