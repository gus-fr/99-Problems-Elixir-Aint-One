defmodule AdventOfCode.Cafeteria do
  @moduledoc """
  code for day 5 of AOC 2025
  https://adventofcode.com/2025/day/5

  """

  @file_name "input/input_day5.txt"

  def main do
    File.stream!(@file_name)
    |> Stream.map(&String.trim/1)
    |> Enum.reduce({[], []}, &build_database/2)
  end

  defp build_database(element, {range_list, item_list}) do
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

  defp parse_range([_, low, high]) do
    elem(Integer.parse(low), 0)..elem(Integer.parse(high), 0)
  end
end
