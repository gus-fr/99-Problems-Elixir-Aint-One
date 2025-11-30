defmodule KVStore.KeyValueStore do
  use GenServer

  @impl GenServer
  def init(_) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  @impl GenServer
  def handle_call({:get, key}, _, state) do
    {:reply, Map.get(state, key), state}
  end

  # interface

  @doc "start kv distributed instance"
  def start do
    GenServer.start(KVStore.KeyValueStore, nil)
  end

  @doc """
  put a value in the kv store
  """
  @spec put(GenServer.server(), term(), term()) :: :ok
  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end
end

# {:ok, pid} = KeyValueStore.start()

# KeyValueStore.put(pid, 3, 123)
# val = KeyValueStore.get(pid, 3)
# IO.puts(val)

# :timer.sleep(1000)
