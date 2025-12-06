defmodule AdventOfCode.Printing do
  @moduledoc """
  code for day 4 of AOC 2025
  https://adventofcode.com/2025/day/4
  usage
  """

  @file_name "input/input_day4.txt"
  @kernel [[1, 1, 1], [1, 0, 1], [1, 1, 1]]

  def main() do
    matrix = read_matrix(@file_name)

    -1*(convo2d(pad_matrix(matrix, 1), 1)
    |> Enum.sum())
  end

  defp convo2d(matrix, window_size) do
    height = length(matrix) - 1
    width = length(List.first(matrix)) - 1

    for i <- window_size..(height - window_size),
        j <- window_size..(width - window_size),
        do:
          (if(Enum.at(Enum.at(matrix, i), j) == 1) do
             apply_convolution_fn(matrix_slice(matrix, i, j, window_size))
           else
             0
           end)
  end

  defp apply_convolution_fn(sliced_matrix) do
    if matrix_prodsum(sliced_matrix, @kernel) < 4 do
      -1
    else
      0
    end
  end

  defp matrix_prodsum(matrix1, matrix2) do
    Stream.zip(List.flatten(matrix1), List.flatten(matrix2))
    |> Enum.reduce(0, fn {x, y}, acc -> acc + x * y end)
  end

  defp matrix_slice(matrix, i, j, window_size) do
    Enum.slice(matrix, (i - window_size)..(i + window_size))
    |> Enum.map(&Enum.slice(&1, (j - window_size)..(j + window_size)))
  end

  defp pad_matrix(matrix, window_size) do
    row_pad = [List.duplicate(0, length(List.first(matrix)) + window_size * 2)]

    col_pad = List.duplicate(0, window_size)

    row_pad ++
      for(
        row <- matrix,
        do: col_pad ++ row ++ col_pad
      ) ++ row_pad
  end

  defp read_matrix(file_name) do
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
