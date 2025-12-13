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
    |> Enum.reduce(MapSet.new(), &add_circuit/2)
    |> MapSet.to_list()
    |> Enum.map(fn x -> length(MapSet.to_list(x)) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(1, fn x, y -> x * y end)
  end

  defp add_circuit({p1, p2, _}, circuits) do
    circuit_1 = Enum.filter(circuits, &MapSet.member?(&1, p1))
    circuit_2 = Enum.filter(circuits, &MapSet.member?(&1, p2))

    cond do
      circuit_1 == [] and circuit_2 == [] ->
        MapSet.put(circuits, MapSet.new([p1, p2]))

      circuit_1 != [] and circuit_2 == [] ->
        MapSet.put(MapSet.delete(circuits, hd(circuit_1)), MapSet.put(hd(circuit_1), p2))

      circuit_1 == [] and circuit_2 != [] ->
        MapSet.put(MapSet.delete(circuits, hd(circuit_2)), MapSet.put(hd(circuit_2), p1))

      true ->
        merge(circuits, hd(circuit_1), hd(circuit_2))
    end
  end

  defp merge(circuits, circuit_1, circuit_2) do
    MapSet.put(
      MapSet.delete(MapSet.delete(circuits, circuit_1), circuit_2),
      MapSet.union(circuit_1, circuit_2)
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
