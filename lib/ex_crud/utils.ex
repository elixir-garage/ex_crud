defmodule ExCrud.Utils do
  @moduledoc false

  def raise_context_not_set_error(nil), do: raise(ExCrud.ContextNotSetError)
  def raise_context_not_set_error(_), do: :ok

  def raise_schema_not_set_error(nil), do: raise(ExCrud.SchemaNotSetError)
  def raise_schema_not_set_error(_), do: :ok

  def raise_missing_changeset_function_error(true), do: :ok

  def raise_missing_changeset_function_error(_),
    do: raise(ExCrud.MissingChangesetFunctionError)
end
