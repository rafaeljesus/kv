defmodule Kv.StoreTest do
  use ExUnit.Case
  alias Kv.{Store}

  @invalid_attrs %{}
  @valid_attrs %{
    name: "187.106.174.27",
    data: %{
      city: "Ilhabela",
      region: "SP",
      country: "Brazil"
    }
  }

  test "changeset with valid attributes" do
    changeset = Store.changeset(%Store{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Store.changeset(%Store{}, @invalid_attrs)
    refute changeset.valid?
  end
end
