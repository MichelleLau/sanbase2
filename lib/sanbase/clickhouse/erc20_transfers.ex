defmodule Sanbase.Clickhouse.Erc20Transfers do
  use Ecto.Schema

  import Ecto.Query
  alias Sanbase.ClickhouseRepo
  alias __MODULE__

  @primary_key false
  @timestamps_opts updated_at: false
  schema "erc20_transfers" do
    field(:dt, :utc_datetime, primary_key: true)
    field(:contract, :string, primary_key: true)
    field(:from, :string, primary_key: true)
    field(:to, :string, primary_key: true)
    field(:transactionHash, :string, primary_key: true)
    field(:value, :float)
    field(:blockNumber, :integer)
    field(:logIndex, :integer)
  end

  def changeset(_, _attrs \\ %{}) do
    raise "Should not try to change eth daily active addresses"
  end

  def top_contract_transfers(contract, from_datetime, to_datetime, size \\ 10) do
    from(
      transfer in Erc20Transfers,
      where:
        transfer.contract == ^contract and transfer.dt > ^from_datetime and
          transfer.dt < ^to_datetime,
      order_by: [desc: transfer.value],
      limit: ^size
    )
    |> ClickhouseRepo.all()
  end

  def count_contract_transfers(contract, from_datetime, to_datetime) do
    from(
      transfer in Erc20Transfers,
      where:
        transfer.contract == ^contract and transfer.dt > ^from_datetime and
          transfer.dt < ^to_datetime,
      select: count("*")
    )
    |> ClickhouseRepo.all()
  end

  def count_contract_transfers_chunked(contract, from_datetime, to_datetime, interval) do
    from(
      transfer in Erc20Transfers,
      where:
        transfer.contract == ^contract and transfer.dt > ^from_datetime and
          transfer.dt < ^to_datetime
    )
  end
end
