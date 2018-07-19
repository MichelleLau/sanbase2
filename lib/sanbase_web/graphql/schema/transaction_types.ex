defmodule SanbaseWeb.Graphql.TransactionTypes do
  use Absinthe.Schema.Notation

  enum :transaction_type do
    value(:in)
    value(:out)
    value(:all)
  end

  object :transaction do
    field(:datetime, non_null(:datetime))
    field(:trx_hash, non_null(:string))
    field(:trx_value, non_null(:float))
    field(:from_address, non_null(:string))
    field(:to_address, non_null(:string))
  end

  object :wallet_transaction do
    field(:datetime, non_null(:datetime))
    field(:trx_hash, :string)
    field(:trx_value, :decimal)
    field(:transaction_type, :string)
    field(:from_address, :string)
    field(:to_address, :string)
  end

  object :funds_flow do
    field(:datetime, non_null(:datetime))
    field(:funds_flow, non_null(:float))
  end
end
