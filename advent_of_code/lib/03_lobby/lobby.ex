defmodule AdventOfCode.Lobby do
  @moduledoc """
  code for day 3 of AOC 2025
  https://adventofcode.com/2025/day/3
  usage AdventOfCode.Lobby.main(2) for part 1
  AdventOfCode.Lobby.main(12) for part 2
  """

  @file_name "input/input_day3.txt"

  def main(max_digits) do
    File.stream!(@file_name)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&convert_to_digitlist/1)
    |> Stream.map(&max_jolt(&1, max_digits))
    |> Enum.sum()
  end

  defp convert_to_digitlist(integer_string) do
    {int, _} = Integer.parse(integer_string)
    Integer.digits(int)
  end

  defp max_jolt(digit_list, num_digits) do
    {max_index, max_value} = max_item_at(digit_list, 1 + length(digit_list) - num_digits)

    if num_digits == 1 do
      max_value
    else
      {_, remainder} = Enum.split(digit_list, max_index + 1)
      max_value * 10 ** (num_digits - 1) + max_jolt(remainder, num_digits - 1)
    end
  end

  defp max_item_at(digit_list, stop_at) do
    {max_index, _, max_value} =
      Enum.reduce_while(digit_list, {0, 0, 1}, &max_lookup(&1, &2, stop_at))

    {max_index, max_value}
  end

  defp max_lookup(digit, {current_max_index, current_index, current_max}, limit) do
    cond do
      current_index >= limit -> {:halt, {current_max_index, current_index, current_max}}
      # early stopping
      digit == 9 -> {:halt, {current_index, current_index, 9}}
      digit > current_max -> {:cont, {current_index, current_index + 1, digit}}
      true -> {:cont, {current_max_index, current_index + 1, current_max}}
    end
  end
end
