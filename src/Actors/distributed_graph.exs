defmodule Graph do
  defstruct nodes: Map.new(), edges: MapSet.new(), directed: false

  def new(nodes, _edges, directed \\ false) do
    %Graph{
      nodes: Map.new(nodes, &add_node(&1)),
      edges: [],
      directed: directed
    }
  end

  defp add_node(node) do
    pid = spawn(fn -> node_loop(MapSet.new()) end)
    {node, pid}
  end

  defp node_loop(node_state) do
    new_node_state =
      receive do
        value -> process_node_message(value, node_state)
      end

    node_loop(new_node_state)
  end

  defp process_node_message(node_state, {:add_neighbor, neighbor}) do
    MapSet.put(node_state, neighbor)
  end
end

a = Graph.new([1, 2], [1, 2])
IO.inspect(a, label: "factorize 1")
