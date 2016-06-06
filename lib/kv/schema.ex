defmodule Kv.Store do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Kv.{Store, Repo}

  @primary_key {:name, :string, []}
  schema "store" do
    field :data, :map
    timestamps
  end

  @required_fields ~w(name data)
  @optional_fields ~w()

  def changeset(schema, params) do
    schema
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:name)
  end

  def get(name) do
    Store
    |> Repo.get_by(name: name)
    |> clean
  end

  def set(name, data) do
    now = Ecto.DateTime.utc
    # FIXME Waiting for ecto release upsert
    sql = "INSERT INTO store (name, data, inserted_at, updated_at)
      VALUES ($1, $2, $3, $3)
      ON CONFLICT (name) DO UPDATE
      SET (data, updated_at) = ($2, $3)
      WHERE EXCLUDED.name = $1;"
    params = [name, data, now]
    Ecto.Adapters.SQL.query(Repo, sql, params)
  end

  def clear do
    Ecto.Adapters.SQL.query(Repo, "TRUNCATE store", [])
  end

  def all do
    Repo.all(from o in Store)
    |> Enum.map(fn(s) -> {s.name, s.data} end)
    |> Map.new
  end

  defp clean(nil), do: nil
  defp clean(%Store{data: data}), do: data
end
