defmodule Sanbase.Clickhouse.EthTransfers do
  use Ecto.Schema

  import Ecto.Query
  import Sanbase.Clickhouse.EctoFunctions

  alias __MODULE__
  alias Sanbase.ClickhouseRepo

  @primary_key false
  @timestamps_opts updated_at: false
  schema "eth_transfers" do
    field(:dt, :utc_datetime, primary_key: true)
    field(:from, :string, primary_key: true)
    field(:to, :string, primary_key: true)
    field(:transactionHash, :string, primary_key: true)
    field(:value, :float)
    field(:blockNumber, :integer)
    field(:transactionPosition, :integer)
  end

  def changeset(_, _attrs \\ %{}) do
    raise "Should not try to change eth transfers"
  end

  @doc ~s"""
  Return the `size` biggest transfers for a given address and time period.
  """
  def top_address_transfers(from, from_datetime, to_datetime, size \\ 10) do
    query =
      from(
        transfer in EthTransfers,
        where:
          transfer.from == ^from and transfer.dt > ^from_datetime and transfer.dt < ^to_datetime,
        order_by: [desc: transfer.value],
        limit: ^size
      )
      |> query_all_use_prewhere()
  end

  @doc ~s"""
  Return the `size` biggest transfers for a given wallet or list of wallets and time period.
  If a list of wallet is provided, then only transfers which `from` address is in the
  list and `to` address is not in the list are selected.
  """
  def top_wallet_transfers(wallets, from_datetime, to_datetime, size \\ 10) do
    wallets = List.wrap(wallets)

    from(
      transfer in EthTransfers,
      where:
        transfer.from in ^wallets and transfer.to not in ^wallets and transfer.dt > ^from_datetime and
          transfer.dt < ^to_datetime,
      order_by: [desc: transfer.value],
      limit: ^size
    )
    |> query_all_use_prewhere()
  end
end
