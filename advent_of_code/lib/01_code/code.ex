defmodule AdventOfCode.Code do
  @moduledoc """
  code for day 1 of AOC 2025
  https://adventofcode.com/2025/day/1
  usage AdventOfCode.Code.main
  """

  @file_name "input/input_day1.txt"
  @size_lock 100
  @start_position 50

  def main_part_1() do
    decode_lock_rotations()
    |> Stream.scan({0,@start_position}, &rotate/2)
    |> Stream.filter(&lock_in_zero?/1)
    |> Enum.reduce(0, fn _, acc -> acc + 1 end)
  end

  defp decode_lock_rotations() do
    File.stream!(@file_name)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&decode_rotation/1)
  end

  defp lock_in_zero?(lock_state) do
    case lock_state do
      {_,0} -> true
      {_,_} -> false
    end
  end

  defp decode_rotation(input_rotation) do
    case String.first(input_rotation) do
      "L" -> {:ok, -1 * parse_number(input_rotation)}
      "R" -> {:ok, parse_number(input_rotation)}
      _ -> :error
    end
  end

  defp parse_number(input_rotation) do
    case Integer.parse(String.slice(input_rotation, 1, String.length(input_rotation))) do
      {number, _} -> number
      _ -> :error
    end
  end

  defp rotate({:ok, code}, {zero_counts,current_position}) do
    {zero_counts+div(current_position+code,@size_lock),Integer.mod(current_position + code, @size_lock)}
  end
end
