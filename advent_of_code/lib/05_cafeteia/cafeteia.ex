defmodule AdventOfCode.Cafeteria do
  @moduledoc """
  code for day 5 of AOC 2025
  https://adventofcode.com/2025/day/5

  """

  @file_name "input/input_day5.txt"

  def main do
    {ranges, ingredients} =
      File.stream!(@file_name)
      |> Stream.map(&String.trim/1)
      |> Enum.reduce({[], []}, &update_database/2)

    Enum.map(ingredients, &fresh?(&1, ranges))
    |> Enum.reduce(0,fn x, acc -> if x == true do 1+acc else acc end end)
  end

  defp update_database(element, {range_list, item_list}) do
    range_match = Regex.run(~r/(\d*)-(\d*)/, element)

    cond do
      range_match != nil ->
        {[parse_range(range_match) | range_list], item_list}

      Regex.match?(~r/(\d+)/, element) ->
        {range_list, [elem(Integer.parse(element), 0) | item_list]}

      true ->
        {range_list, item_list}
    end
  end

  defp fresh?(ingredient, ranges) do
    Enum.any?(ranges,fn range -> ingredient in range end)
  end

  defp parse_range([_, low, high]) do
    elem(Integer.parse(low), 0)..elem(Integer.parse(high), 0)
  end
end
