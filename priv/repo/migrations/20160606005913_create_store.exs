defmodule Kv.Repo.Migrations.CreateStore do
  use Ecto.Migration

  def change do
    create table(:store, primary_key: false) do
      add :name, :string, primary_key: true
      add :data, :map
      timestamps
    end
  end
end
