defmodule AdventOfCode.Playground do
  @moduledoc """
  code for day 7 of AOC 2025
  https://adventofcode.com/2025/day/7

  """

  @file_name "input/input_day8.txt"

  def main() do
    load_data()
    |> distance_matrix()
    |> Enum.sort_by(&elem(&1, 2))
    |> Enum.take(1000)
    |> Enum.reduce(%{}, &add_circuit/2)
    |> Map.to_list()
    |> Enum.map(fn x -> length(MapSet.to_list(elem(x, 1))) end)
    |> Enum.sort(:desc)

    |> Enum.take(3)
    |> Enum.reduce(1,fn x,y -> x*y end)

    #    |> length()
  end

  defp add_circuit({p1, p2, distance}, circuits) do
    circuit_key_p1 =
      for key <- Map.keys(circuits),
          MapSet.member?(Map.get(circuits, key), p1),
          do: key

    circuit_key_p2 =
      for key <- Map.keys(circuits),
          MapSet.member?(Map.get(circuits, key), p2),
          do: key

    cond do
      length(circuit_key_p1) == 0 and length(circuit_key_p2) == 0 ->
        Map.put(circuits, distance, MapSet.new([p1, p2]))

      length(circuit_key_p1) > 0 and length(circuit_key_p2) == 0 ->
        Map.update(circuits, hd(circuit_key_p1), nil,fn x -> MapSet.put(x, p1) end)

      length(circuit_key_p1) ==0 and length(circuit_key_p2) >0 ->
        Map.update(circuits, hd(circuit_key_p2),nil, fn x -> MapSet.put(x, p2) end)

      true ->
        merge(circuits, hd(circuit_key_p1), hd(circuit_key_p2))
    end
  end

  defp merge(circuits, circuit_key_p1, circuit_key_p2) do
    c1 = Map.get(circuits, circuit_key_p1)
    c2 = Map.get(circuits, circuit_key_p2)

    Map.put(
      Map.drop(circuits, [circuit_key_p1, circuit_key_p2]),
      circuit_key_p1,
      MapSet.union(c1, c2)
    )
  end

  defp point_distance({x1, y1, z1}, {x2, y2, z2}) do
    :math.sqrt(Integer.pow(x1 - x2, 2) + Integer.pow(y1 - y2, 2) + Integer.pow(z1 - z2, 2))
  end

  defp distance_matrix(points) do
    for i <- points, j <- points, i < j, do: {i, j, point_distance(i, j)}
  end

  defp load_data() do
    File.stream!(@file_name)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_coordinates/1)
    |> MapSet.new()
  end

  defp parse_coordinates(line) do
    [x, y, z] =
      String.split(line, ",")
      |> Stream.map(&Integer.parse/1)
      |> Stream.map(&elem(&1, 0))
      |> Enum.to_list()

    {x, y, z}
  end
end
