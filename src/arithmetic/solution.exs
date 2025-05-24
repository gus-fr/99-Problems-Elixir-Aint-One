defmodule Arithmetic do
  @doc "is input a number prime"
  @spec prime?(number()) :: boolean()
  def prime?(2) do
    true
  end
  def prime?(input) do
    if is_integer(input) and input> 1 do
      length(remainders(input)
      |> Stream.filter(&(&1 == 0))
      |>Enum.take(1))==0
    else
      {:error, "bad input"}
    end
  end


  def remainders(input) do
    Stream.map(2..ceil(:math.sqrt(input)), &(rem input,&1))
  end
end

IO.inspect(Enum.map(2..9,&Arithmetic.prime?/1), label: "data")
