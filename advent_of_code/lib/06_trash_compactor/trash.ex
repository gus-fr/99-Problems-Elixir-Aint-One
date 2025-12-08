defmodule AdventOfCode.TrashCompactor do
  @moduledoc """
  code for day 6 of AOC 2025
  https://adventofcode.com/2025/day/6

  """

  @file_name "input/input_day6.txt"

  def part1 do
    read_matrix(@file_name)
    |> transpose
    |> Stream.map(&parse_symbols/1)
    |> Stream.map(&solve_problem/1)
    |> Enum.sum()
  end

  def main() do
    # solve part 2
    text_list =
      File.stream!(@file_name)
      |> Stream.map(&String.replace(&1, "\n", ""))
      |> Enum.to_list()

    num_to_split = get_number_ranges(Enum.at(text_list, 4))

    Stream.map(text_list, &split_string(&1, num_to_split))
    |> transpose
    |> Stream.map(fn x -> Enum.map(x, &pad_symbol/1) end)
    |> Stream.map(fn x -> Enum.map(x, &String.graphemes/1) end)
    |> Stream.map(&transpose/1)
    |> Stream.map(fn x -> Enum.map(x, &digitize(&1, 0)) end)
    |> Stream.map(&solve_problem_vertival/1)
    |> Enum.sum()
  end

  defp solve_problem_vertival([{number, _} | []]) do
    number
  end

  defp solve_problem_vertival([{number, operation} | tail]) do
    operation.(number, solve_problem_vertival(tail))
  end

  defp digitize([operator | []], acc) do
    cond do
      operator == "+" -> {acc, &+/2}
      operator == "*" -> {acc, &*/2}
      true -> raise("sth went wrong")
    end
  end

  defp digitize([digit | tail], acc) do
    cond do
      Regex.match?(~r/(\d+)/, digit) ->
        digitize(tail, acc * 10 + elem(Integer.parse(digit), 0))

      digit == "x" ->
        digitize(tail, acc)

      true ->
        raise("sth went wrong #{digit}, #{acc}")
    end
  end

  defp split_string(string, [_ | []]) do
    [string]
  end

  defp split_string(string, [head | tail]) do
    tuple = String.split_at(string, head + 1)
    [String.slice(elem(tuple, 0), 0..-2//1) | split_string(elem(tuple, 1), tail)]
  end

  defp pad_symbol(symbol) do
    cond do
      Regex.match?(~r/\s*\d+\s*/, symbol) ->
        String.replace(symbol, " ", "x")

      Regex.match?(~r/\s*\+\s*/, symbol) ->
        String.replace(symbol, " ", "+")

      Regex.match?(~r/\s*\*\s*/, symbol) ->
        String.replace(symbol, " ", "*")

      true ->
        raise("sth went match for #{symbol} not found")
    end
  end

  defp get_number_ranges(operation_list) do
    operation_list
    |> String.split(~r/\S+/)
    |> Enum.map(&String.length/1)
    |> tl
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
