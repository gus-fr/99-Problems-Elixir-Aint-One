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
  def gcd(number1, number2)
      when is_integer(number1) and is_integer(number2) and number1 > 0 and number2 > 0 do
    gcd_recursive(max(number1, number2), min(number1, number2))
  end

  defp gcd_recursive(bigger, smaller) do
    if smaller == 0 do
      bigger
    else
      gcd_recursive(smaller, rem(bigger, smaller))
    end
  end

  def coprime?(a, b), do: gcd(a, b) == 1

  @doc """
  Euler's so-called totient function phi(m)
  is defined as the number of positive integers r (1 <= r < m) that are coprime to m.
  """
  @spec totient_phi(integer) :: integer
  def totient_phi(1), do: 1

  def totient_phi(n) when n > 1 do
    Stream.map(1..(n - 1), &coprime?(&1, n))
    |> Enum.count(&(&1 == true))
  end

  @doc """
  fatorize
  """
  @spec prime_factors(integer) :: list(integer)
  def prime_factors(1), do: [1]

  def prime_factors(n) when n > 1 and is_integer(n) do
    if prime?(n) do
      [n]
    else
      factor = first_factor(n)
      [factor | prime_factors(div(n, factor))]
    end
  end

  defp first_factor(n) do
    Stream.map(2..n, fn x -> {x, rem(n, x)} end)
    |> Stream.filter(&(elem(&1, 1) == 0))
    |> Enum.take(1)
    |> List.first()
    |> elem(0)
  end
end

IO.inspect(Arithmetic.prime_factors(1), label: "factorize 1")
IO.inspect(Arithmetic.prime_factors(2), label: "factorize 2")
IO.inspect(Arithmetic.prime_factors(60), label: "factorize 60")
IO.inspect(Arithmetic.prime_factors(123456789), label: "factorize 123456789")


IO.inspect(Arithmetic.totient_phi(1), label: "phi(1)")
IO.inspect(Arithmetic.totient_phi(10), label: "phi(10)=4")
IO.inspect(Arithmetic.totient_phi(7727), label: "phi(7727)=7726")

IO.inspect(Arithmetic.coprime?(35, 64), label: "oprime(35,64)=yes")
IO.inspect(Arithmetic.gcd(3, 5), label: "GCD(5,3)=1")
IO.inspect(Arithmetic.gcd(36, 63), label: "GCD(36,63)=9")
IO.inspect(Arithmetic.gcd(1071, 462), label: "GCD(1071,462)=21")

IO.inspect(Enum.map(2..9, &Arithmetic.prime?/1), label: "primes 2..9")
