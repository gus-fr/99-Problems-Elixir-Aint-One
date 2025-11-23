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

  def ping(graph, node) do
    case Map.fetch(graph.nodes, node) do
      {:ok, node_pid} -> send(node_pid, {:ping, []})
      :error -> raise("bad ping node #{node}")
    end
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
          :error -> raise("bad to node #{to}")
        end

      :error ->
        raise("bad node: '#{from}'")
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
    update_in(node_state.neighbors, &MapSet.put(&1, neighbor))
  end

  defp process_node_message(node_state, {:ping, stak_call}) do
    IO.inspect(stak_call, label: "node #{node_state.node_id} called w stack")

    case Enum.find_index(stak_call, fn x -> x == node_state.node_id end) do
      nil -> Enum.each(node_state.neighbors, &send(&1, {:ping, [node_state.node_id | stak_call]}))
      _ -> IO.inspect(stak_call, label: "loop avoided")
    end

    node_state
  end
end

g = Graph.new([1, 2, 3, 4, 5, 6, 7], [[1, 2], [1, 3], [2, 4], [2, 6], [3, 5], [3, 7], [7,1]])
Graph.ping(g, 1)
Graph.ping(g, 5)
IO.puts("foo")
:timer.sleep(1000)
IO.puts("bar")
