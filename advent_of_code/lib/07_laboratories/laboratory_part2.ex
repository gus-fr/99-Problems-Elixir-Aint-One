defmodule AdventOfCode.LaboratoryII do
  @moduledoc """
  code for day 7 of AOC 2025
  https://adventofcode.com/2025/day/7

  """

  @file_name "input/input_day7.txt"

  def main() do
    lines =
      read_input_stream()
      |> Stream.map(&decode_line/1)

    first = Stream.take(lines, 1) |> Enum.at(0) |> Enum.at(0)
    rest = Stream.drop(lines, 1)

    advance_all_beams(%{first => 1}, rest)
    |> Map.values()
    |> Enum.sum()
  end

  defp advance_all_beams(current_beams, splitters) do
    splitter = Stream.take(splitters, 1) |> Enum.at(0)

    cond do
      splitter == nil ->
        current_beams

      length(splitter) > 0 ->
        new_beams = advance_beam(current_beams, splitter)
        advance_all_beams(new_beams, Stream.drop(splitters, 1))
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

  defp reduce_beams(beam, aggregated_map, spliter_idxs) do
    beam_idx = elem(beam, 0)
    beam_ct = elem(beam, 1)

    if Enum.member?(spliter_idxs, beam_idx) do
      first_map = Map.update(aggregated_map, beam_idx + 1, beam_ct, fn x -> x + beam_ct end)
      Map.update(first_map, beam_idx - 1, beam_ct, fn x -> x + beam_ct end)
    else
      Map.update(aggregated_map, beam_idx, beam_ct, fn x -> x + beam_ct end)
    end
  end

  def advance_beam(beam_counts, spliter_idxs) do
    Enum.reduce(beam_counts, %{}, &reduce_beams(&1, &2, spliter_idxs))
  end
end
