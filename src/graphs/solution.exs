defmodule GraphNode do
  defstruct node_id: nil
end

defmodule Edge do
  defstruct from: nil, to: nil, weight: 0

  def new(from, to, weight \\ 0) do
    %Edge{
      from: from,
      to: to,
      weight: weight
    }
  end
end

defmodule Graph do
  defstruct nodes: MapSet.new(), edges: MapSet.new(), directed: false

  def new(nodes, edges, directed \\ false) do
    %Graph{
      nodes: MapSet.new(nodes, &%GraphNode{node_id: &1}),
      edges: MapSet.new(edges, &add_edge(&1, directed)),
      directed: directed
    }
  end

  defp add_edge(edge_defn, directed) do
    case edge_defn do
      [from, to] ->
        if directed == true do
          %Edge{from: from, to: to}
        else
          %Edge{from: min(from, to), to: max(from, to)}
        end
    end
  end

  @doc "run length encoding"
  @spec paths(Graph, GraphNode, GraphNode) :: list[list[GraphNode]]
  def paths(graph, a, b) do
    c = graph.nodes
    [a, b, c]
  end
end

defmodule Main do
  def main do
    graph = Graph.new([1, 2, 3], [[1,2],[2,1],[3,1]], false)
    IO.inspect(graph, label: "test")
  end
end

Main.main()
