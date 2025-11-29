defmodule KVStore.Cache do
  use GenServer

  @impl GenServer
  def init(_) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:server_process, kv_name}, _, map_kv_servers) do
    case Map.fetch(map_kv_servers, kv_name) do
      {:ok, server} ->
        {:reply, server, map_kv_servers}

      :error ->
        {:ok, new_server} = KVStore.KeyValueStore.start()

        {
          :reply,
          new_server,
          Map.put(map_kv_servers, kv_name, new_server)
        }
    end
  end
end
