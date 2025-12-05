defmodule AdventOfCode.Printing do
  @moduledoc """
  code for day 4 of AOC 2025
  https://adventofcode.com/2025/day/4
  usage
  """

  @file_name "input/input_day4.txt"

  def main() do
    read_matrix(@file_name)
  end

  def read_matrix(file_name) do
    File.stream!(file_name)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
    |> Stream.map(&Enum.map(&1, fn x -> char_to_bool!(x) end))
    |> Enum.to_list()
  end

  defp char_to_bool!(char) do
    case char do
      "@" -> 1
      "." -> 0
      _ -> raise("bad char input #{char}")
    end
  end
end
