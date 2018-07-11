defmodule Sanbase.Clickhouse.Erc20DailyActiveAddresses do
  use Ecto.Schema

  import Ecto.Query
  alias Sanbase.ClickhouseRepo
  alias __MODULE__

  # @primary_key {:dt, :date, []}
  # @timestamps_opts updated_at: false

  schema "erc20_daily_active_addresses" do
    field(:dt, :naive_datetime)
    field(:contract, :string)
    field(:address, :string)
    field(:total_transactions, :integer)
  end

  def changeset(_, _attrs \\ %{}) do
    raise "Should not try to change eth daily active addresses"
  end

  def count_erc20_daa(contract, from_datetime, to_datetime) do
    from(
      daa in Erc20DailyActiveAddresses,
      where: daa.dt > from_datetime and daa.dt < to_datetime,
      group_by: daa.dt,
      order_by: daa.dt,
      select: {daa.dt, count("*")}
    )
    |> ClickhouseRepo.all()
  end
end
