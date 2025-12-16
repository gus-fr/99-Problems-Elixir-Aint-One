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

  def main_part2() do
    data = load_data()
    contours = draw_contour(data)
    data |> areas(contours)
    |> Enum.max()

  end

  defp load_data() do
    File.stream!(@file_name)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_coordinates/1)
    |> Enum.to_list()
  end

  defp draw_contour(points) do
    Stream.chunk_every(points, 2, 1, Stream.cycle(points))
    |> Stream.map(&line/1)
    |> Enum.reduce(MapSet.new(),&MapSet.union()/2)
  end

  defp line([{x1, y1}, {x2, y2}]) do
    cond do
      x1 == x2 -> explode_points(x1, {min(y1, y2), max(y1, y2)})
      y1 == y2 -> explode_points({min(x1, x2), max(x1, x2)}, y1)
      true -> raise("bad format")
    end
  end

  defp explode_points(x, {y1, y2}) do
    for y <- y1..y2, into: MapSet.new() do
      {x, y}
    end
  end

  defp explode_points({x1, x2}, y) do
    for x <- x1..x2, into: MapSet.new() do
      {x, y}
    end
  end

  defp areas(points,contour) do
    for p1 <- points, p2 <- points, filter_points(p1,p2,contour), do: area(p1, p2)
  end

  defp filter_points({x1,y1},{x2,y2},contour) do
    if x1<= x2 do
      :true
    else
      if in_contour({x1,y2},contour) and in_contour({x2,y1},contour) do
        :true
      end
      :false
    end
  end

  defp in_contour(point,contour) do
    for p1 <- contour, p2 <- contour, point_in_line(point,p1,p2), do: :true

  end

  defp point_in_line({x,y},{x1,y1},{x2,y2}) do
    cond do
      x==x1 and x==x2 and min(y1,y2) <= y and y<= max(y1,y2) -> :true
      y==y1 and y==y2 and min(x1,x2) <= x and x<= max(x1,x2) -> :true
      :true -> :false
    end
  end

  defp areas(points) do
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
