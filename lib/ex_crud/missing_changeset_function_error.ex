defmodule ExCrud.MissingChangesetFunctionError do
  @moduledoc false

  defexception message: "expected schema_module to have a changeset/1 function"
end
