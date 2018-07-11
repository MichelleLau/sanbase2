defmodule Sanbase.Clickhouse.EthDailyActiveAddresses do
  use Ecto.Schema

  import Ecto.Query
  alias Sanbase.ClickhouseRepo
  alias __MODULE__

  # @timestamps_opts updated_at: false

  @primary_key false
  schema "eth_daily_active_addresses" do
    field(:dt, :utc_datetime, primary_key: true)
    field(:address, :string, primary_key: true)
    field(:total_transactions, :integer)
  end

  def changeset(_, _attrs \\ %{}) do
    raise "Should not try to change eth daily active addresses"
  end

  def count_eth_daa(from_datetime, to_datetime) do
    from(
      daa in EthDailyActiveAddresses,
      where: daa.dt > ^from_datetime and daa.dt < ^to_datetime,
      group_by: daa.dt,
      order_by: daa.dt,
      select: {daa.dt, count("*")}
    )
    |> ClickhouseRepo.all()
  end
end
