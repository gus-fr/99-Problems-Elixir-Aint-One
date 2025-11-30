defmodule KVStore.CacheTest do
  use ExUnit.Case

  test "server_process" do
    {:ok, cache} = KVStore.Cache.start()
    bob_pid = KVStore.Cache.server_process(cache, "bob")
    assert bob_pid != KVStore.Cache.server_process(cache, "alice")
    assert bob_pid == KVStore.Cache.server_process(cache, "bob")
  end
end
