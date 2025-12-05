defmodule AdventOfCode.Printing do
  @moduledoc """
  code for day 4 of AOC 2025
  https://adventofcode.com/2025/day/4
  usage
  """

  @file_name "input/input_day4.txt"

  def main() do
    matrix = read_matrix(@file_name)

    convo2d(matrix, 1)
    |> Enum.filter(fn x -> x < 4 end)
    |> length
  end

  # line_above == nil -> Stream.repeatedly(fn -> 0 end)
  def convo2d(matrix, window_size) do
    height = length(matrix) - 1
    width = length(List.first(matrix)) - 1

    for i <- 0..height,
        j <- 0..width,
        Enum.at(Enum.at(matrix, i), j) == 1,
        do: Enum.sum(Enum.map(matrix_slice(matrix, i, j, window_size), &Enum.sum/1)) - 1
  end

  defp matrix_slice(matrix, i, j, window_size) do
    Enum.slice(matrix, max(i - window_size, 0)..(i + window_size))
    |> Enum.map(&Enum.slice(&1, max(j - window_size, 0)..(j + window_size)))
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
