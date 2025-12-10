defmodule AdventOfCode.Laboratory do
  @moduledoc """
  code for day 7 of AOC 2025
  https://adventofcode.com/2025/day/7

  """

  @file_name "input/input_day7.txt"

  def main() do
    lines =
      read_input_stream()
      |> Stream.map(&decode_line/1)

    first = Stream.take(lines, 1) |> Enum.at(0)
    rest = Stream.drop(lines, 1)
    advance_all_beams(first, rest)
  end

  defp advance_all_beams(current_beams, splitters) do
    splitter = Stream.take(splitters, 1) |> Enum.at(0)
    # IO.puts("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
    # IO.inspect(Enum.to_list(splitters), charlists: false)

    cond do
      splitter == nil ->
        0

      length(splitter) > 0 ->
        {new_beams, num_splits} = advance_beam(current_beams, {[], 0}, splitter)
        num_splits + advance_all_beams(new_beams, Stream.drop(splitters, 1))
    end
  end

  defp read_input_stream() do
    File.stream!(@file_name)
    |> Stream.map(&String.trim/1)
    |> Stream.take_every(2)
    |> Stream.map(&String.graphemes/1)
  end

  defp decode_line(stream_line) do
    Stream.with_index(stream_line)
    |> Stream.filter(fn {char, _} -> char != "." end)
    |> Stream.map(&elem(&1, 1))
    |> Enum.to_list()
  end

  def advance_beam([beam_idx | []], {new_beams, splits}, spliter_idxs) do
    if Enum.member?(spliter_idxs, beam_idx) do
      {Enum.uniq([beam_idx - 1, beam_idx + 1 | new_beams]), splits + 1}
    else
      {Enum.uniq([beam_idx | new_beams]), splits}
    end
  end

  def advance_beam([beam_idx | other_beams], {new_beams, splits}, spliter_idxs) do
    # IO.inspect(new_beams, charlists: :as_lists)

    if Enum.member?(spliter_idxs, beam_idx) do
      advance_beam(
        other_beams,
        {Enum.uniq([beam_idx - 1, beam_idx + 1 | new_beams]), splits + 1},
        spliter_idxs
      )
    else
      advance_beam(other_beams, {Enum.uniq([beam_idx | new_beams]), splits}, spliter_idxs)
    end
  end
end
