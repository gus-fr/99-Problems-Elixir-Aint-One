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
  def prime_factors(n), do: Enum.to_list(factor_stream(n))

  def factor_stream(n) do
    Stream.unfold({2, n}, &next_factor/1)
  end

  def factor_mult(n) do
    Stream.transform(stream_pairs(factor_stream(n)), 1, fn
      {x, x}, acc -> {[], acc + 1}
      {x, _}, acc -> {[{x, acc}], 1}
    end)
  end

  defp first_factor(n, start_from) do
    # {factor,remainder} for all numbers
    Stream.map(start_from..n, fn x -> {x, rem(n, x)} end)
    # filter only the numbers divisible by n
    |> Stream.filter(&(elem(&1, 1) == 0))
    # take the first one from the stream
    |> Enum.take(1)
    # unwrap the list
    |> List.first()
    # take the factor from {factor,remainder} tuple
    |> elem(0)
  end

  defp next_factor({_, 1}) do
    nil
  end

  defp next_factor({current_factor, n}) when n > 1 and is_integer(n) do
    # returns the next prime factor, and reduces the acc by acc/factor
    factor = first_factor(n, current_factor)
    result = div(n, factor)
    {factor, {factor, result}}
  end

  defp stream_pairs(stream) do
    Stream.transform(
      stream,
      fn -> nil end,
      fn
        x, nil -> {[], x}
        x, prev -> {[{prev, x}], x}
      end,
      # sends a last pair
      fn x -> {[{x, nil}], nil} end,
      fn _ -> nil end
    )
  end
end

IO.inspect(Enum.to_list(Arithmetic.factor_mult(1)), label: "factorize 1")
IO.inspect(Enum.to_list(Arithmetic.factor_mult(2)), label: "factorize 2")
IO.inspect(Enum.to_list(Arithmetic.factor_mult(60)), label: "factorize 60")
IO.inspect(Enum.to_list(Arithmetic.factor_mult(1024)), label: "factorize 1024")

IO.inspect(Arithmetic.prime_factors(1), label: "factorize 1")
IO.inspect(Arithmetic.prime_factors(2), label: "factorize 2")
IO.inspect(Arithmetic.prime_factors(60), label: "factorize 60")
IO.inspect(Arithmetic.prime_factors(1024), label: "factorize 1024")

IO.inspect(Arithmetic.prime_factors(123_456_789), label: "factorize 123456789")

IO.inspect(Arithmetic.totient_phi(1), label: "phi(1)")
IO.inspect(Arithmetic.totient_phi(10), label: "phi(10)=4")
IO.inspect(Arithmetic.totient_phi(7727), label: "phi(7727)=7726")

IO.inspect(Arithmetic.coprime?(35, 64), label: "oprime(35,64)=yes")
IO.inspect(Arithmetic.gcd(3, 5), label: "GCD(5,3)=1")
IO.inspect(Arithmetic.gcd(36, 63), label: "GCD(36,63)=9")
IO.inspect(Arithmetic.gcd(1071, 462), label: "GCD(1071,462)=21")

IO.inspect(Enum.map(2..9, &Arithmetic.prime?/1), label: "primes 2..9")
