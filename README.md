# ExCrud

## A module that injects crud based functions into a context module for use in Ecto based applications

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_crud` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_crud, "~> 0.1.0"}
  ]
end
```


## Call the `use ExCrud` macro to inject crud functions into the context module

- In each Context Module - you want to use the crud functions
  -----------------------------------------------------------

    defmodule MyApp.Post do
      use ExCrud, context: MyApp.Repo, schema_module: MyApp.Post.PostSchema
    end


- List of the Crud functions available in the context module
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

- Inspiration
  -----------

- Here are two existing libraries that inspired this one and I stand on their shoulders. I just wanted to
do this slightly differently and hence this library.

- https://github.com/PavelDotsenko/CRUD
- https://github.com/jungsoft/crudry
