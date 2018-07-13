defmodule Sanbase.Clickhouse.EctoFunctions do
  @doc ~s"""
  For performance reasons, `WHERE` should be replaced with `PREWHERE`.
  This cannot be done with Ecto expressions. Because of that we're converting the
  query to a string and replacing the words.
  Executing raw SQL will return a map with `columns`, `command`, `num_rows` and `rows`
  that should be manually transformed to the needed struct
  """
  defmacro query_all_use_prewhere(query) do
    quote bind_quoted: [query: query] do
      {query, args} = Ecto.Adapters.SQL.to_sql(:all, Sanbase.ClickhouseRepo, query)
      query = query |> String.replace(" WHERE ", " PREWHERE ")
      result = Ecto.Adapters.SQL.query!(Sanbase.ClickhouseRepo, query, args)

      Enum.map(result.rows, &Sanbase.ClickhouseRepo.load(__MODULE__, {result.columns, &1}))
    end
  end
end
