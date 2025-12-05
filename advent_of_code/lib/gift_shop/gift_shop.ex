defmodule AdventOfCode.GiftShop do
  @moduledoc """
  code for day 2 of AOC 2025
  https://adventofcode.com/2025/day/2
  usage AdventOfCode.GiftShop.main(&AdventOfCode.GiftShop.invalid_id_twice?/1) fo part 1

  """

  @file_name "input/input_day2.txt"

  def main(invalid_id_fn) do
    File.read!(@file_name)
    |> String.split(",")
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.map(&tuple_to_range/1)
    |> Enum.map(&invalid_id_sum(&1, invalid_id_fn))
    |> Enum.sum()
  end

  defp tuple_to_range([first, last]) do
    {first_num, _} = Integer.parse(first)
    {last_num, _} = Integer.parse(last)
    first_num..last_num
  end

  defp invalid_id_sum(range, filte_fn) do
    Stream.filter(range, filte_fn)
    |> Enum.sum()
  end

  def invalid_id_twice?(int_id) do
    digits = floor(:math.log10(int_id)) + 1
    shift = 10 ** div(digits, 2)

    if Integer.mod(digits, 2) == 0 do
      Integer.mod(int_id, shift) == div(int_id, shift)
    else
      false
    end
  end

  def invalid_id_muli?(int_id) do
    digits = Integer.digits(int_id)

    case length(digits) do
      1 ->
        false

      _ ->
        1..div(length(digits), 2)
        |> Enum.map(&repeated_patten?(&1, digits))
        |> Enum.any?()
    end
  end

  def repeated_patten?(pattern_size, list) do
    {pattern, rest} = Enum.split(list, pattern_size)

    cond do
      length(rest) == pattern_size -> pattern == rest
      length(rest) == 0 -> false
      pattern == Enum.take(rest, pattern_size) -> repeated_patten?(pattern_size, rest)
      true -> false
    end
  end
end
