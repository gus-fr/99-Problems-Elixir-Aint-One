defmodule Arithmetic do
  @doc "is input a number prime"
  @spec prime?(number()) :: boolean()
  def prime?(2) do
    true
  end

  def prime?(input) do
    if is_integer(input) and input > 1 do
      length(
        remainders(input)
        |> Stream.filter(&(&1 == 0))
        |> Enum.take(1)
      ) == 0
    else
      {:error, "bad input"}
    end
  end

  defp remainders(input) do
    Stream.map(2..ceil(:math.sqrt(input)), &rem(input, &1))
  end

  @doc """
  the gcd using euclideqn algo. only poitive ints
  """
  @spec gcd(integer, integer) :: integer
  def gcd(number1, number2) when is_integer(number1) and is_integer(number2) do
    gcd_recursive(max(number1, number2), min(number1, number2))
  end

  defp gcd_recursive(bigger, smaller) do
    if smaller == 0 do
      bigger
    else
      gcd_recursive(smaller, rem(bigger, smaller))
    end
  end
end

IO.inspect(Arithmetic.gcd(3, 5), label: "GCD(5,3)=1")
IO.inspect(Arithmetic.gcd(36, 63), label: "GCD(36,63)=9")
IO.inspect(Arithmetic.gcd(1071, 462), label: "GCD(1071,462)=21")

IO.inspect(Enum.map(2..9, &Arithmetic.prime?/1), label: "primes 2..9")
