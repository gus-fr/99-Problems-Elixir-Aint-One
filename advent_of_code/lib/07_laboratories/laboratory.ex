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

    test =
      advance_beam(Enum.at(lines, 0), {[], 0}, Enum.at(lines, 1))
      #|> elem(0)
      #IO.inspect(test, charlists: :as_lists)
  end

  defp advance_all_beams() do

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

  defp advance_beam([beam_idx | []], {new_beams, splits}, spliter_idxs) do
    if Enum.member?(spliter_idxs, beam_idx) do
      {[beam_idx - 1, beam_idx + 1 | new_beams], splits + 1}
    else
      {[beam_idx | new_beams], splits}
    end
  end

  defp advance_beam([beam_idx | other_beams], {new_beams, splits}, spliter_idxs) do
    if Enum.member?(spliter_idxs, beam_idx) do
      advance_beam(
        other_beams,
        {[beam_idx - 1, beam_idx + 1 | new_beams], splits + 1},
        spliter_idxs
      )
    else
      advance_beam(other_beams, {[beam_idx | new_beams], splits}, spliter_idxs)
    end
  end
end
