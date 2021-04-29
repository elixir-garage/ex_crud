defmodule ExCrud.Utils do
  @moduledoc false

  def raise_context_not_set_error(nil), do: raise(ExCrud.ContextNotSetError)
  def raise_context_not_set_error(_), do: :ok

  def raise_schema_not_set_error(nil), do: raise(ExCrud.SchemaNotSetError)
  def raise_schema_not_set_error(_), do: :ok
end
