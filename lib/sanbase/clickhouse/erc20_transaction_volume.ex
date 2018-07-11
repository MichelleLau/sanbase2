defmodule Sanbase.Clickhouse.Erc20TransactionVolume do
  use Ecto.Schema

  import Ecto.Query
  alias Sanbase.ClickhouseRepo
  alias __MODULE__

  @primary_key false
  @timestamps_opts updated_at: false
  schema "erc20_transaction_volume" do
    field(:dt, :utc_datetime, primary_key: true)
    field(:contract, :string, primary_key: true)
    field(:value, :string, primary_key: true)
    field(:total_transactions, :integer)
  end

  def changeset(_, _attrs \\ %{}) do
    raise "Should not try to change eth daily active addresses"
  end

  def count_erc20_daa(contract, from_datetime, to_datetime) do
    from(
      daa in Erc20TransactionVolume,
      where: daa.contract == ^contract and daa.dt > ^from_datetime and daa.dt < ^to_datetime,
      select: {daa.dt, count("*")},
      group_by: daa.dt,
      order_by: daa.dt
    )
    |> ClickhouseRepo.all()
  end
end
