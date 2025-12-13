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
    |> Enum.reduce(%{}, &add_circuit/2)
    |> Enum.to_list()
    |> length()

    #    |> length()
  end

  defp add_circuit({p1, p2, distance}, circuits) do
    new_map =
      for key <- Map.keys(circuits),
          MapSet.member?(Map.get(circuits, key), p1) or
            MapSet.member?(Map.get(circuits, key), p2),
          into: %{} do
        {key, MapSet.put(MapSet.put(Map.get(circuits, key), p1), p2)}
      end

    if Map.equal?(new_map, %{}) do
      Map.put(circuits, distance, MapSet.new([p1, p2]))
    else
      Map.put(circuits, hd(Map.keys(new_map)), hd(Map.values(new_map)))
    end
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
