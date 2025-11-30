defmodule KVStore.CacheTest do
  use ExUnit.Case

  test "server_process" do
    KVStore.Cache.start()
    bob_pid = KVStore.Cache.server_process("bob")
    assert bob_pid != KVStore.Cache.server_process("alice")
    assert bob_pid == KVStore.Cache.server_process("bob")
  end

  test "to-do operations" do
    KVStore.Cache.start()
    alice = KVStore.Cache.server_process("alice")
    KVStore.KeyValueStore.put(alice, ~D[2023-12-19], "value1")
    entries = KVStore.KeyValueStore.get(alice, ~D[2023-12-19])
    assert "value1" = entries
  end
end
