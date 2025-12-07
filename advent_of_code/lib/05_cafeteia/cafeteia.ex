defmodule AdventOfCode.Cafeteria do
  @moduledoc """
  code for day 5 of AOC 2025
  https://adventofcode.com/2025/day/5
  Usage
  fresh_ingredient_from_list part 1
  fresh_ingredient_from_range for part 2
  """

  @file_name "input/input_day5.txt"

  def fresh_ingredient_from_list do
    {ranges, ingredients} = load_data()

    Enum.map(ingredients, &fresh?(&1, ranges))
    |> Enum.reduce(0, fn x, acc ->
      if x == true do
        1 + acc
      else
        acc
      end
    end)
  end

  def fresh_ingredient_from_range do
    {ranges, _} = load_data()

    Enum.sort(ranges)
    |> dedup_ranges
  end

  defp dedup_ranges(sorted_ranges) do
    Enum.map_reduce(sorted_ranges, nil, fn x, acc ->
      {range_difference(acc, x), forward_range(acc, x)}
    end)
    |> elem(0)
    |> Enum.sum()
  end

  defp range_difference(early_range, later_range) do
    cond do
      early_range == nil ->
        range_size(later_range)

      early_range.last < later_range.first ->
        range_size(later_range)

      early_range.last < later_range.last ->
        range_size((early_range.last + 1)..later_range.last)

      early_range.last >= later_range.last ->
        0

      true ->
        raise(
          "sth went wrong #{early_range.first}..#{early_range.last} : #{later_range.first}..#{later_range.last}"
        )
    end
  end

  defp forward_range(early_range, later_range) do
    cond do
      early_range == nil ->
        later_range

      early_range.last < later_range.first ->
        later_range

      early_range.last < later_range.last ->
        (early_range.last + 1)..later_range.last

      early_range.last >= later_range.last ->
        early_range

      true ->
        raise(
          "sth went wrong in acc #{early_range.first}..#{early_range.last} : #{later_range.first}..#{later_range.last}"
        )
    end
  end

  defp range_size(range) do
    1 + range.last - range.first
  end

  defp load_data() do
    File.stream!(@file_name)
    |> Stream.map(&String.trim/1)
    |> Enum.reduce({[], []}, &update_database/2)
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
    Enum.any?(ranges, fn range -> ingredient in range end)
  end

  defp parse_range([_, low, high]) do
    elem(Integer.parse(low), 0)..elem(Integer.parse(high), 0)
  end
end
