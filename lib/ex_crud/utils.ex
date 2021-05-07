defmodule ExCrud.Utils do
  @moduledoc false

  def raise_context_not_set_error(nil), do: raise(ExCrud.ContextNotSetError)
  def raise_context_not_set_error(_), do: :ok

  def raise_schema_not_set_error(nil), do: raise(ExCrud.SchemaNotSetError)
  def raise_schema_not_set_error(_), do: :ok

  def raise_missing_changeset_function_error(true), do: :ok

  def raise_missing_changeset_function_error(_),
    do: raise(ExCrud.MissingChangesetFunctionError)

  def check_changeset_function(schema) do
    case Code.ensure_loaded(schema) do
      {:module, module} ->
        module
        |> function_exported?(:changeset, 1)
        |> ExCrud.Utils.raise_missing_changeset_function_error()

      {:error, _load_error} ->
        nil
        |> ExCrud.Utils.raise_schema_not_set_error()
    end
  end
end
