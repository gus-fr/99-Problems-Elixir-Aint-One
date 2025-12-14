defmodule AdventOfCode.Movie do
  @moduledoc """
  code for day 9 of AOC 2025
  https://adventofcode.com/2025/day/9

  """

  @file_name "input/input_day9.txt"

  def main_part1() do
    load_data()
    |> areas()
    |> Enum.max()
  end

  defp load_data() do
    File.stream!(@file_name)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_coordinates/1)
    |> Enum.to_list()
  end

  def areas(points) do
    for p1 <- points, p2 <- points, elem(p1, 0) <= elem(p2, 0), do: area(p1, p2)
  end

  defp area({x1, y1}, {x2, y2}) do
    (1 + abs(x1 - x2)) * (1 + abs(y1 - y2))
  end

  defp parse_coordinates(line) do
    [x, y] =
      String.split(line, ",")
      |> Stream.map(&Integer.parse/1)
      |> Stream.map(&elem(&1, 0))
      |> Enum.to_list()

    {x, y}
  end
end
