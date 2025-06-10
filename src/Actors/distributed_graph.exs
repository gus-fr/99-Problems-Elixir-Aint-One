defmodule GraphNode do
  defstruct node_id: nil, neighbors: MapSet.new()

  def new(node_id, neighbors \\ MapSet.new()) do
    %GraphNode{node_id: node_id, neighbors: neighbors}
  end
end

defmodule Graph do
  defstruct nodes: Map.new(), directed: false

  def new(nodes, edges, directed \\ false) do
    graph = %Graph{
      nodes: Map.new(nodes, &add_node(&1)),
      directed: directed
    }

    Enum.each(edges, &add_edge(graph, &1))
    graph
  end

  defp add_node(node) do
    pid = spawn(fn -> node_loop(GraphNode.new(node)) end)
    {node, pid}
  end

  defp add_edge(graph, [from, to | []]) do
    case Map.fetch(graph.nodes, from) do
      {:ok, from_pid} ->
        case Map.fetch(graph.nodes, to) do
          {:ok, to_pid} -> send(from_pid, {:add_neighbor, to_pid})
          {:error, _} -> raise("bad to node #{to}")
        end

      {:error, _} ->
        raise("bad from node #{from}")
    end
  end

  defp node_loop(node_state) do
    new_node_state =
      receive do
        value -> process_node_message(node_state, value)
      end

    node_loop(new_node_state)
  end

  defp process_node_message(node_state, {:add_neighbor, neighbor}) do
    put_in(node_state.neighbors, neighbor)
  end
end

a = Graph.new([1, 2, 3, 4], [[1, 2], [2, 3], [2, 4]])
IO.inspect(a, label: "factorize 1")
