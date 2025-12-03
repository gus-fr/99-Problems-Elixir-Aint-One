defmodule AdventOfCode.Code do
  @file_name "input.txt"
  @size_lock 100
  @start_position 50

  def decode() do
    File.stream!(@file_name)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&decode_rotation/1)
    |> Stream.scan(@start_position,&rotate/2)
    |> Stream.filter(&(&1 == 0))
    |> Enum.reduce(0,fn _, acc-> acc+1 end)
  end




  defp decode_rotation(input_rotation) do
    case String.first(input_rotation) do
      "L" -> {:ok, -1*parse_number(input_rotation)}
      "R" -> {:ok, parse_number(input_rotation)}
      _ -> :error
    end
  end

  defp parse_number(input_rotation) do
    case Integer.parse(String.slice(input_rotation,1,String.length(input_rotation))) do
      {number,_} -> number
      _ -> :error
    end
  end

  defp rotate({:ok,code},accumulator) do
    Integer.mod(accumulator + code, @size_lock)
  end
end
