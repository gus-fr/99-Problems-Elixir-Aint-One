defmodule AdventOfCode.GiftShop do
  @moduledoc """
  code for day 2 of AOC 2025
  https://adventofcode.com/2025/day/2
  usage AdventOfCode.GiftShop.main
  """

  @file_name "input/input_day2.txt"


  def main() do
    File.read!(@file_name)
    |> String.split(",")
    |> Enum.map(&String.split(&1,"-"))



  end

  defp expand_range(first,last) do
    first..last
  end
end
