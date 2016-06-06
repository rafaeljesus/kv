defmodule Kv.StoreTest do
  use ExUnit.Case
  alias Kv.{Store, Repo}

  @invalid_attrs %{}
  @valid_attrs %{
    name: "187.106.174.27",
    data: %{
      city: "Ilhabela",
      region: "SP",
      country: "Brazil"
    }
  }

  setup do
    on_exit fn ->
      Repo.delete_all(Store)
    end
  end

  test "should changeset with valid attributes" do
    changeset = Store.changeset(%Store{}, @valid_attrs)
    assert changeset.valid?
  end

  test "should changeset with invalid attributes" do
    changeset = Store.changeset(%Store{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "should get data from store" do
    with {:ok, changeset} <- Store.changeset(%Store{}, @valid_attrs),
      {:ok, store} <- Repo.insert(changeset),
      {:ok, value} <- Store.get(store.name),
      do: assert value["city"] == @valid_attrs.data.city
  end

  test "should set data in store" do
    with {:ok, _} <- Store.set(@valid_attrs.name, @valid_attrs.data),
      {:ok, value} <- Store.get(@valid_attrs.name),
      do: assert value["city"] == @valid_attrs.data.city
  end
end
