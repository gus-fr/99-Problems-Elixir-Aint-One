defmodule AdventOfCode.Factory do
  @moduledoc """
  code for day 10 of AOC 2025
  https://adventofcode.com/2025/day/10

  """

  @file_name "input/input_day10.txt"

  def main_part1() do
    load_data()
    |> Stream.map(&find_button_combination/1)
    |> Stream.map(&length/1)
    |> Enum.sum()
  end

  def main_part2() do
    load_datav2()
    |> Stream.map(&find_button_combination_v2/1)
    |> Stream.map(fn x -> Enum.map(x, &elem(&1, 1)) end)
    |> Stream.map(&Enum.min/1)
  end

  defp load_data() do
    File.stream!(@file_name)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_line/1)
  end

  defp load_datav2() do
    File.stream!(@file_name)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_linev2/1)
  end

  # **********************************bfs v2***************************************

  defp find_button_combination_v2({_, buttons, joltage}) do
    initial_state = Tuple.duplicate(0, tuple_size(joltage))

    sorted_indices =
      Tuple.to_list(joltage)
      |> Enum.zip(0..(tuple_size(joltage) - 1))
      |> Enum.sort(:asc)
      |> Enum.map(&elem(&1, 1))

    focused_bfs([{initial_state, 0}], buttons, joltage, sorted_indices)
  end

  defp search_until_single_target([], acc, _, _, _) do
    acc
  end

  # AdventOfCode.Factory.main_part2 |> Stream.take(1) |> Enum.to_list
  defp search_until_single_target(
         joltage_states,
         acc_reults,
         buttons,
         {target_joltage, target_index},
         target_joltage_state
       ) do
    {accumulated_results, new_states} =
      Stream.flat_map(joltage_states, fn {state, level} ->
        Stream.map(buttons, fn button ->
          {transition_joltage(state, button), level + 1}
        end)
      end)
      |> Stream.filter(&valid_state?(elem(&1, 0), target_joltage_state))
      |> Enum.uniq_by(&elem(&1, 0))
      |> Enum.split_with(&has_joltage_at?(elem(&1, 0), target_joltage, target_index))

    search_until_single_target(
      new_states,
      accumulated_results ++
        acc_reults,
      buttons,
      {target_joltage, target_index},
      target_joltage_state
    )
  end

  defp has_joltage_at?(state, joltage, index) do
    elem(state, index) == joltage
  end

  defp does_not_have_joltage_at?(state, joltage, index) do
    elem(state, index) != joltage
  end

  defp focused_bfs(states, _, _, []) do
    states
  end

  defp focused_bfs(states, buttons, joltage, [index | indices]) do
    new_states =
      search_until_single_target(
        Enum.filter(states, &does_not_have_joltage_at?(elem(&1, 0), elem(joltage, index), index)),
        Enum.filter(states, &has_joltage_at?(elem(&1, 0), elem(joltage, index), index)),
        select_buttons_with_value(buttons, index),
        {elem(joltage, index), index},
        joltage
      )

    focused_bfs(
      new_states,
      remove_buttons_with_value(buttons, index),
      joltage,
      indices
    )
  end

  defp select_buttons_with_value(buttons, value) do
    Enum.filter(buttons, fn button -> value in button end)
  end

  defp remove_buttons_with_value(buttons, value) do
    Enum.filter(buttons, fn button -> value not in button end)
  end

  defp valid_state?(state, final_state) do
    out_of_range =
      for i <- 0..(tuple_size(state) - 1),
          do: elem(state, i) <= elem(final_state, i)

    Enum.all?(out_of_range)
  end

  defp transition_joltage(joltages, button) do
    Enum.reduce(button, joltages, fn x, joltage ->
      put_elem(joltage, x, elem(joltage, x) + 1)
    end)
  end

  # ************************************ bfs V1 *************************************************
  defp find_button_combination({final_state, buttons, _}) do
    initial_state = Tuple.duplicate(false, tuple_size(final_state))
    bsf_search([{initial_state, [], buttons}], final_state)
  end

  defp bsf_search(current_states, final_state) do
    new_stack =
      for {state, history, unpressed_buttons} <- current_states,
          button <- unpressed_buttons,
          do:
            {transition(state, button), [button | history],
             MapSet.delete(unpressed_buttons, button)}

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

  # *********************************************************************************
  defp parse_linev2(line) do
    parse_line_elementsv2(Regex.run(~r/(\[.+\])(.+)(\{.+\})/, line))
  end

  defp parse_line_elementsv2([_, indicators, buttons, joltage]) do
    {parse_indicators(indicators), parse_buttonsv2(buttons), parse_joltage(joltage)}
  end

  defp parse_buttonsv2(buttons) do
    String.trim(buttons)
    |> String.split(" ")
    |> Enum.map(&parse_button/1)
  end

  # *************************** input parsing ***********************************
  defp parse_line(line) do
    parse_line_elements(Regex.run(~r/(\[.+\])(.+)(\{.+\})/, line))
  end

  defp parse_line_elements([_, indicators, buttons, joltage]) do
    {parse_indicators(indicators), parse_buttons(buttons), parse_joltage(joltage)}
  end

  defp parse_joltage(joltage) do
    String.replace(joltage, ~r/\{|\}/, "")
    |> String.split(",")
    |> Stream.map(&Integer.parse/1)
    |> Stream.map(&elem(&1, 0))
    |> Enum.to_list()
    |> List.to_tuple()
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
