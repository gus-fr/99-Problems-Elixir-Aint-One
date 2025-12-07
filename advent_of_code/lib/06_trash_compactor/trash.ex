defmodule AdventOfCode.TrashCompactor do
  @moduledoc """
  code for day 6 of AOC 2025
  https://adventofcode.com/2025/day/6

  """

  @file_name "input/input_day6.txt"

  def main() do
    read_matrix(@file_name)
    |> transpose
    |> Stream.map(&parse_symbols/1)
    |> Stream.map(&solve_problem/1)
    |> Enum.sum()
  end

  defp read_matrix(file_name) do
    File.stream!(file_name)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, ~r/\s+/))
    |> Enum.to_list()
  end

  def transpose([]), do: []
  def transpose([[] | _]), do: []

  def transpose(list) do
    [Enum.map(list, &hd/1) | transpose(Enum.map(list, &tl/1))]
  end

  defp solve_problem({numbers, {operation, unit}}) do
    Enum.reduce(numbers, unit, operation)
  end

  defp parse_symbols(symbol_list) do
    Enum.reduce(symbol_list, {[], {nil, nil}}, &parse_symbol/2)
  end

  defp parse_symbol(symbol, {number_list, {operator, unit}}) do
    cond do
      Regex.match?(~r/(\d+)/, symbol) ->
        {[elem(Integer.parse(symbol), 0) | number_list], {operator, unit}}

      symbol == "+" ->
        {number_list, {&+/2, 0}}

      symbol == "*" ->
        {number_list, {&*/2, 1}}

      true ->
        raise("sth went wrong")
    end
  end
end
