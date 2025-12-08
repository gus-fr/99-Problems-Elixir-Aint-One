defmodule AdventOfCode.Laboratory do
  @moduledoc """
  code for day 7 of AOC 2025
  https://adventofcode.com/2025/day/7

  """

  @file_name "input/input_day7.txt"

  def main() do
    input_stream = read_input_stream()
    decode_start_index(Enum.take(input_stream, 1))
  end

  defp read_input_stream() do
    File.stream!(@file_name)
    |> Stream.map(&String.trim/1)
    |> Stream.take_every(2)
    |> Stream.map(&String.graphemes/1)
  end

  defp decode_start_index(first_line) do
    hd(first_line) |> Enum.find_index(fn x -> x == "S" end)
  end
end
