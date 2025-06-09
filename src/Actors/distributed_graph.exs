defmodule Graph do
  defstruct nodes: Map.new(), edges: MapSet.new(), directed: false

  def new(nodes, edges, directed \\ false) do
    %Graph{
      nodes: MapSet.new(nodes, nodes),
      edges: MapSet.new(edges),
      directed: directed
    }
  end

  def add_node(graph, node_key, node) do
    Map.put(graph.nodes, node_key, node)
  end
end

defmodule GraphServer do
  def new(graph) do

    Enum.each(graph.nodes,&add_node(,&1))

  end

  def add_node(graph, node) do
    pid = spawn(fn -> node_loop(MapSet.new()) end)
    Graph.add_node(graph, pid, node)
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

GraphServer.new()
IO.inspect(Enum.to_list(Arithmetic.factor_mult(1)), label: "factorize 1")
