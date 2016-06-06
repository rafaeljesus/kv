defmodule Kv.Worker do
  use GenServer
  alias Kv.{Worker, Store}

  def start_link() do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def set(k, v) do
    :ok = GenServer.cast(Worker, {:set, k, v})
  end

  def get(k) do
    GenServer.call(Worker, {:get, k})
  end

  def clear do
    :ok = GenServer.cast(Worker, :clear)
  end

  def init(_), do: {:ok, zero_state}

  def handle_cast({:set, k, v}, state) do
    Store.set(k, v)
    {:noreply, state |> Map.put(k, v)}
  end

  def handle_cast(:clear, _state) do
    Store.clear
    {:noreply, zero_state}
  end

  def handle_call({:get, k}, _from, state) do
    {:reply, state |> Map.get(k), state}
  end

  defp zero_state, do: Store.all
end
