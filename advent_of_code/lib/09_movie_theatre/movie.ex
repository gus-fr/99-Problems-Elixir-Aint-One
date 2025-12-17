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

    contours =
      draw_contour(data)
      |> Enum.to_list()

    {upper, lower} = def_bounds(contours)

    x_index =
      contours |> Enum.reduce(%{}, &reduce_index_x(&1, &2, elem(lower, 1), elem(upper, 1)))

    y_index =
      contours |> Enum.reduce(%{}, &reduce_index_y(&1, &2, elem(lower, 1), elem(upper, 1)))

    File.write!("contours.txt", inspect(Enum.sort(contours), pretty: true, limit: :infinity))
    File.write!("y_index.txt", inspect(y_index, pretty: true, limit: :infinity))
    File.write!("x_index.txt", inspect(x_index, pretty: true, limit: :infinity))

    data
    |> areas(x_index, y_index)
    |> Enum.max()
  end

  def reduce_index_x({x, y}, acc_map, min_y, max_y) do
    {curr_min, curr_max} = Map.get(acc_map, x, {max_y, min_y})
    Map.put(acc_map, x, {min(y, curr_min), max(y, curr_max)})
  end

  def reduce_index_y({x, y}, acc_map, min_x, max_x) do
    {curr_min, curr_max} = Map.get(acc_map, y, {max_x, min_x})
    Map.put(acc_map, y, {min(x, curr_min), max(x, curr_max)})
  end

  defp def_bounds(contours) do
    upper_x =
      contours
      |> Enum.map(&elem(&1, 0))
      |> Enum.reduce(0, &max/2)

    lower_x =
      contours
      |> Enum.map(&elem(&1, 0))
      |> Enum.reduce(upper_x, &min/2)

    upper_y =
      contours
      |> Enum.map(&elem(&1, 1))
      |> Enum.reduce(0, &max/2)

    lower_y =
      contours
      |> Enum.map(&elem(&1, 1))
      |> Enum.reduce(upper_y, &min/2)

    {{upper_x, upper_y}, {lower_x, lower_y}}
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
    |> Enum.reduce(MapSet.new(), &MapSet.union/2)
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

  defp areas(points, x_index, y_index) do
    for p1 <- points, p2 <- points, in_contour(p1, p2, x_index, y_index), do: area(p1, p2)
  end

  defp in_contour({x1, y1}, {x2, y2}, x_index, y_index) do
    {lower_y1, upper_y1} = Map.get(x_index, x1)
    {lower_y2, upper_y2} = Map.get(x_index, x2)
    {lower_x1, upper_x1} = Map.get(y_index, y1)
    {lower_x2, upper_x2} = Map.get(y_index, y2)

    cond do
      y2 < lower_y1 -> false
      y2 > upper_y1 -> false
      x2 < lower_x1 -> false
      x2 > upper_x1 -> false
      y1 < lower_y2 -> false
      y1 > upper_y2 -> false
      x1 < lower_x2 -> false
      x1 > upper_x2 -> false
      true -> true
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
