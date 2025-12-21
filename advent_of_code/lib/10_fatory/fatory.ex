defmodule AdventOfCode.Factory do
  @moduledoc """
  code for day 10 of AOC 2025
  https://adventofcode.com/2025/day/10

  """

  @file_name "input/input_day10.txt"

  def main_part1() do
    load_data()
  end

  defp load_data() do
    File.stream!(@file_name)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_line/1)
    |> Stream.map(&find_button_combination/1)
    |> Stream.map(&length/1)
    |> Enum.sum()
  end

  defp find_button_combination({final_state, buttons, _}) do
    initial_state = Tuple.duplicate(false, tuple_size(final_state))
    bsf_search([{initial_state, [], buttons}], final_state)
  end

  defp bsf_search(current_states, final_state) do
    new_stack =
      for {state, history, unpressed_buttons} <- current_states,
          button <- unpressed_buttons,
          do: {transition(state, button), [button | history], MapSet.delete(unpressed_buttons,button)}

    solutions = Enum.filter(new_stack, fn {state, _, _} -> state == final_state end)

    case solutions do
      [] -> bsf_search(new_stack, final_state)
      [solution | _] -> elem(solution, 1)
    end
  end

  defp transition(indicator, button) do
    Enum.reduce(button, indicator, fn x, indicator ->
      put_elem(indicator, x, not elem(indicator, x))
    end)
  end

  defp parse_line(line) do
    parse_line_elements(Regex.run(~r/(\[.+\])(.+)(\{.+\})/, line))
  end

  defp parse_line_elements([_, indicators, buttons, joltage]) do
    {parse_indicators(indicators), parse_buttons(buttons), joltage}
  end

  defp parse_buttons(buttons) do
    String.trim(buttons)
    |> String.split(" ")
    |> Enum.map(&parse_button/1)
    |> MapSet.new()
  end

  defp parse_button(button) do
    String.replace(button, ~r/\(|\)/, "")
    |> String.split(",")
    |> Stream.map(&Integer.parse/1)
    |> Stream.map(&elem(&1, 0))
    |> Enum.to_list()
  end

  defp parse_indicators(indicators) do
    String.graphemes(indicators)
    |> Stream.map(&parse_indicator/1)
    |> Stream.filter(fn x -> x != nil end)
    |> Enum.to_list()
    |> List.to_tuple()
  end

  defp parse_indicator(indicator) do
    case indicator do
      "[" -> nil
      "." -> false
      "#" -> true
      "]" -> nil
    end
  end
end
