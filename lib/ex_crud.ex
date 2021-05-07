defmodule ExCrud do
  @moduledoc """
    A module that injects crud based functions into a context module for use in Ecto based applications

    Call the `use ExCrud` macro to inject crud functions into the context module

    In each Context Module - you want to use the crud functions
    -----------------------------------------------------------

      defmodule MyApp.Post do
        use ExCrud, context: MyApp.Repo, schema_module: MyApp.Post.PostSchema
      end


    List of the Crud functions available in the context module
    ----------------------------------------------------------

    - `add/1`

        ## Examples:
      - `iex> MyApp.Post.add(%{key1: value1, key2: value2})`
        `{:ok, struct}`
      - `iex> MyApp.Post.add(key1: value1, key2: value)`
        `{:ok, struct}`

    - `get/1`

      ## Examples:
        - `iex> MyApp.Post.get(1)`
          `{:ok, struct}`

        - `iex> MyApp.Post.get(id: 1)`
          `{:ok, struct}`

        - `iex> MyApp.Post.get(%{id: 1})`
          `{:ok, struct}`

    - `get_all/0`

      ## Examples
        - `iex> MyApp.Post.get_all()`
        `{:ok, list of structures}`

    - `get_few/1`

      ## Examples
        - `iex> MyApp.Post.get_few(200)`
          `{:ok, list of structures}`

    - `update/2`

      ## Examples
        - `iex> MyApp.Post.update(struct, key: value)`
          `{:ok, list of structures}`

        - `iex> MyApp.Post.update(struct, %{key: value})`
          `{:ok, list of structures}`

        - `iex> MyApp.Post.update(id, key: value)`
          `{:ok, list of structures}`

        - `iex> MyApp.Post.update(id, %{key: value})`
          `{:ok, list of structures}`

    - `delete/1`

      ## Examples
        - `iex> MyApp.Post.delete(1)`
          `{:ok, structure}`

        - `iex> MyApp.Post.delete(struct)`
          `{:ok, structure}`

    Inspiration
    -----------

    - Here are two existing libraries that inspired this one and I stand on their shoulders. I just wanted to
    do this slightly differently and hence this library.

    - https://github.com/PavelDotsenko/CRUD
    - https://github.com/jungsoft/crudry
  """

  @moduledoc since: "1.0.5"

  use Ecto.Schema

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      import Ecto.Query, only: [from: 2, where: 2, where: 3, offset: 2]

      @cont Keyword.get(opts, :context)
      @schema Keyword.get(opts, :schema_module)

      ExCrud.Utils.raise_context_not_set_error(@cont)
      ExCrud.Utils.raise_schema_not_set_error(@schema)

      @doc """
      Returns the current Repo
      """
      def context(), do: @cont

      @doc """
      Adds a new entity to the database
      ## Takes in parameters:
        - `opts`: Map or paramatras key: value separated by commas

      ## Returns:
        - `{:ok, struct}`
        - `{:error, error as a string or list of errors}`

      ## Examples:
        - `iex> MyApp.Post.add(%{key1: value1, key2: value2})`
          `{:ok, struct}`
        - `iex> MyApp.Post.add(key1: value1, key2: value)`

          `{:ok, struct}`
      """
      def add(opts), do: @cont.insert(set_field(@schema, opts)) |> response(@schema)

      @doc """
      Retrieves structure from DB

      ## Takes in parameters:
        - Using `id` records from the database
          - `id`: Structure identifier in the database
        - Search by a bunch of `keys: value` of a record in the database
          - `opts`: Map or paramatras `keys: value` separated by commas

      ## Returns:
        - `{:ok, struct}`
        - `{:error, error as a string}`

      ## Examples:
        - `iex> MyApp.Post.add(1)`

          `{:ok, struct}`
        - `iex> MyApp.Post.add(id: 1)`

          `{:ok, struct}`
        - `iex> MyApp.Post.add(%{id: 1})`

          `{:ok, struct}`
      """
      def get(id) when is_integer(id) or is_binary(id) do
        @cont.get(@schema, id) |> response(@schema)
      end

      @doc """
      Retrieves structure from DB

      ## Takes in parameters:
        - Using `id` records from the database
          - `id`: Structure identifier in the database
        - Search by a bunch of `keys: value` of a record in the database
          - `opts`: Map or paramatras `keys: value` separated by commas

      ## Returns:
        - `{:ok, struct}`
        - `{:error, error as a string}`

      ## Examples:
        - `iex> MyApp.Post.get(1)`
          `{:ok, struct}`

        - `iex> MyApp.Post.get(id: 1)`
          `{:ok, struct}`

        - `iex> MyApp.Post.get(%{id: 1})`
          `{:ok, struct}`
      """
      def get(opts) when is_list(opts) or is_map(opts) do
        @cont.get_by(@schema, opts_to_map(opts)) |> response(@schema)
      end

      @doc """
      Returns a list of structures from the database corresponding to the given Module

      ## Takes in parameters:

      ## Returns:
        - `{:ok, list of structures}`
        - `{:ok, []}`

      ## Examples
        - `iex> MyApp.Post.get_all()`

        `{:ok, list of structures}`
      """
      def get_all() do
        {:ok, @cont.all(from(item in @schema, select: item, order_by: item.id))}
      end

      @doc """
      Returns a list of structures from the database corresponding to the given Module

      ## Takes in parameters:
        - `opts`: Map or paramatras `keys: value` separated by commas

      ## Returns
        - `{:ok, list of structures}`
        - `{:ok, []}`

      ## Examples
        - `iex> MyApp.Post.add(id: 1)`

          `{:ok, list of structures}`
        - `iex> MyApp.Post.add(%{id: 1})`

          `{:ok, list of structures}`
      """
      def get_all(opts) when is_list(opts) or is_map(opts) do
        {:ok, @cont.all(from(i in @schema, select: i, order_by: i.id) |> filter(opts))}
      end

      @doc """
      Returns the specified number of items for the module

      ## Takes in parameters:
        - `limit`: Number of items to display

      ## Returns
        - `{:ok, list of structures}`
        - `{:ok, []}`

      ## Examples
        - `iex> MyApp.Post.get_few(200)`

          `{:ok, list of structures}`
      """
      def get_few(limit) when is_integer(limit) do
        {:ok, @cont.all(from(i in @schema, select: i, order_by: i.id, limit: ^limit))}
      end

      @doc """
      Returns the specified number of items for a module starting from a specific item

      ## Takes in parameters:
        - `limit`: Number of items to display
        - `offset`: First element number

      ## Returns
        - `{:ok, list of structures}`
        - `{:ok, []}`

      ## Examples
        - `iex> MyApp.Post.get_few(200, 50)`

          `{:ok, list of structures}`
      """
      def get_few(limit, offset) when is_integer(limit) and is_integer(offset) do
        query = from(i in @schema, select: i, order_by: i.id, limit: ^limit, offset: ^offset)
        {:ok, @cont.all(query)}
      end

      @doc """
      Returns the specified number of items for a module starting from a specific item

      ## Takes in parameters:
        - `limit`: Number of items to display
        - `opts`: Map or paramatras `keys: value` separated by commas

      ## Returns
        - `{:ok, list of structures}`
        - `{:ok, []}`

      ## Examples
        - `iex> MyApp.Post.get_few(200, key: value)`

          `{:ok, list of structures}`
        - `iex> MyApp.Post.get_few(200, %{key: value})`

          `{:ok, list of structures}`
      """
      def get_few(limit, opts) when is_list(opts) or is_map(opts) do
        query = from(i in @schema, select: i, order_by: i.id, limit: ^limit)
        {:ok, @cont.all(query |> filter(opts))}
      end

      @doc """
      Returns the specified number of items for a module starting from a specific item

      ## Takes in parameters:
        - `limit`: Number of items to display
        - `offset`: First element number
        - `opts`: Map or paramatras `keys: value` separated by commas

      ## Returns
        - `{:ok, list of structures}`
        - `{:ok, []}`

      ## Examples
        - `iex> MyApp.Post.get_few(200, 50, key: value)`

          `{:ok, list of structures}`
        - `iex> MyApp.Post.get_few(200, 50, %{key: value})`

          `{:ok, list of structures}`
      """
      def get_few(limit, offset, opts) when is_list(opts) or is_map(opts) do
        query = from(i in @schema, select: i, limit: ^limit)
        {:ok, @cont.all(query |> filter(opts) |> offset(^offset))}
      end

      @doc """
      Makes changes to the structure from the database

      ## Takes in parameters:
        - `item`: Structure for change
        - `opts`: Map or paramatras `keys: value` separated by commas

      ## Returns
        - `{:ok, list of structures}`
        - `{:ok, []}`

      ## Examples
        - `iex> MyApp.Post.update(item, key: value)`

          `{:ok, list of structures}`
        - `iex> MyApp.Post.update(item, %{key: value})`

          `{:ok, list of structures}`
      """

      def update(%@schema{} = item, opts) when is_struct(item) do
        ExCrud.Utils.check_changeset_function(item.__struct__)

        item.__struct__.changeset(item, opts_to_map(opts))
        |> @cont.update()
      end

      @doc """
      Makes changes to the structure from the database

      ## Takes in parameters:
        - `id`: Structure identifier in the database
        - `opts`: Map or paramatras `keys: value` separated by commas

      ## Returns
        - `{:ok, structure}`
        - `{:ok, error as a string or list of errors}`

      ## Examples
        - `iex> MyApp.Post.update(1, key: value)`

          `{:ok, structure}`
        - `iex> MyApp.Post.update(1, %{key: value})`

          `{:ok, structure}`
      """
      def update(id, opts) when is_integer(id) or is_binary(id),
        do: get(id) |> update_response(opts)

      @doc """
      Makes changes to the structure from the database

      ## Takes in parameters:
        - `key`: Field from structure
        - `val`: Field value
        - `opts`: Map or paramatras `keys: value` separated by commas

      ## Returns
        - `{:ok, structure}`
        - `{:error, error as a string or list of errors}`

      ## Examples
        - `iex> MyApp.Post.update(key, 1, key: value)`

          `{:ok, structure}`
        - `iex> MyApp.Post.update(key, 1, %{key: value})`

          `{:ok, structure}`
      """
      def update(key, val, opts), do: get([{key, val}]) |> update_response(opts)

      @doc """
      Removes the specified structure from the database

      ## Takes in parameters:
        - `item`: Structure

      ## Returns
        - `{:ok, structure}`
        - `{:error, error as a string or list of errors}`

      ## Examples
        - `iex> MyApp.Post.delete(structure)`

          `{:ok, structure}`
      """
      def delete(%@schema{} = item) when is_struct(item) do
        try do
          @cont.delete(item)
        rescue
          _ -> {:error, module_title(item) <> " is not fount"}
        end
      end

      @doc """
      Removes the specified structure from the database

      ## Takes in parameters:
        - `id`: Structure identifier in the database

      ## Returns
        - `{:ok, structure}`
        - `{:error, error as a string or list of errors}`

      ## Examples
        - `iex> MyApp.Post.delete(1)`

          `{:ok, structure}`
      """
      def delete(id), do: get(id) |> delete_response()

      @doc """
      Returns a list of structures in which the values of the specified fields partially or completely correspond to the entered text

      ## Takes in parameters:
        - `id`: Structure identifier in the database

      ## Returns
        - `{:ok, list of structures}`
        - `{:ok, []}`

      ## Examples
        - `iex> MyApp.Post.find(key: "sample")`

          `{:ok, list of structures}`
        - `iex> MyApp.Post.find(%{key: "sample"})`

          `{:ok, list of structures}`
      """
      def find(opts),
        do: from(item in @schema, select: item) |> find(opts_to_map(opts), Enum.count(opts), 0)

      defp set_field(mod, opts) do
        ExCrud.Utils.check_changeset_function(mod)

        mod.changeset(mod.__struct__, opts_to_map(opts))
      end

      defp opts_to_map(opts) when is_map(opts), do: opts

      defp opts_to_map(opts) when is_list(opts),
        do: Enum.reduce(opts, %{}, fn {key, value}, acc -> Map.put(acc, key, value) end)

      defp find(query, opts, count, acc) do
        {key, val} = Enum.at(opts, acc)
        result = query |> where([i], ilike(field(i, ^key), ^"%#{val}%"))

        if acc < count - 1,
          do: find(result, opts, count, acc + 1),
          else: {:ok, @cont.all(result)}
      end

      defp filter(query, opts), do: filter(query, opts, Enum.count(opts), 0)

      defp filter(query, opts, count, acc) do
        fields = Map.new([Enum.at(opts, acc)]) |> Map.to_list()
        result = query |> where(^fields)

        if acc < count - 1, do: filter(result, opts, count, acc + 1), else: result
      end

      defp module_title(mod) when is_struct(mod), do: module_title(mod.__struct__)
      defp module_title(mod), do: Module.split(mod) |> Enum.at(Enum.count(Module.split(mod)) - 1)

      defp error_handler(err) when is_struct(err),
        do: Enum.map(err.errors, fn {key, {msg, _}} -> error_str(key, msg) end)

      defp error_handler(err) when is_tuple(err),
        do: Enum.map([err], fn {_, message} -> message end)

      defp error_handler(error), do: error

      defp delete_response({:error, reason}), do: {:error, error_handler(reason)}
      defp delete_response({:ok, item}), do: delete(item)

      defp update_response({:error, reason}, _opts), do: {:error, error_handler(reason)}
      defp update_response({:ok, item}, opts), do: update(item, opts)

      defp response(nil, mod), do: {:error, module_title(mod) <> " not found"}
      defp response({:error, reason}, _module), do: {:error, error_handler(reason)}
      defp response({:ok, item}, _module), do: {:ok, item}
      defp response(item, _module), do: {:ok, item}

      defp error_str(key, msg), do: "#{Atom.to_string(key) |> String.capitalize()}: #{msg}"
    end
  end
end
