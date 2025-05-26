defmodule ListManipulation do
  @doc "get the last item of a list"
  @spec last([any]) :: any
  def last(input_list) do
    case input_list do
      [] -> {:error, "Empty List"}
      [head | []] -> {:ok, head}
      [_ | tail] -> last(tail)
      _ -> {:error, "Not A List"}
    end
  end

  @doc "get the last 2 items of a list"
  @spec last2(list[any]) :: any
  def last2(input_list) do
    case input_list do
      [] -> {:error, "Empty List"}
      [_ | []] -> {:error, "only 1 item"}
      [head, head2 | []] -> {:ok, [head, head2]}
      [_ | tail] -> last2(tail)
      _ -> {:error, "Not A List"}
    end
  end

  @doc "get the list length with an accumulator"
  @spec list_length(list[any], integer) :: integer
  def list_length(input_list, acc \\ 0) do
    case input_list do
      [] -> acc
      [_ | tail] -> list_length(tail, acc + 1)
    end
  end

  @doc "get the element at the kth index"
  @spec element_at(list[any], integer) :: any
  def element_at(input_list, k) do
    cond do
      not is_integer(k) ->
        {:error, "k not an int"}

      list_length(input_list) < k ->
        {:error, "k greater than list length"}

      true ->
        case {input_list, k} do
          {[], _} -> {:error, "Empty List"}
          {[head | _], 0} -> {:ok, head}
          {[_ | tail], _} -> element_at(tail, k - 1)
        end
    end
  end

  @doc "reverse a list"
  @spec reverse_list(list[any]) :: list[any]
  def reverse_list(input_list, acc \\ []) do
    case input_list do
      [] -> acc
      [head | tail] -> reverse_list(tail, [head | acc])
    end
  end

  @doc "find if it's a palindrome"
  @spec palindrome?(list[any]) :: boolean
  def palindrome?(input_list) do
    input_list == reverse_list(input_list)
  end

  @doc "flatten"
  @spec flatten(list[any]) :: list[any]
  def flatten(input_list) do
    case input_list do
      [] -> []
      [head | tail] -> flatten(head) ++ flatten(tail)
      _ -> [input_list]
    end
  end

  @doc "compress eliminate duplicates"
  @spec compress(list[any]) :: list[any]
  def compress(input_list) do
    case input_list do
      [head, head | tail] -> compress([head | tail])
      [head | tail] -> [head | compress(tail)]
      [] -> []
    end
  end

  @doc "pack duplicates"
  @spec pack(list[any]) :: list[any]
  def pack(input_list, current_pack \\ []) do
    case current_pack do
      [] ->
        case input_list do
          [head, head | tail] -> pack([head | tail], [head])
          [head | tail] -> [head | pack(tail)]
          [] -> []
        end

      [head_pack | _] ->
        case input_list do
          [] ->
            [current_pack]

          [head | tail] when head_pack == head ->
            pack(tail, [head | current_pack])

          [head, head | tail] ->
            [current_pack | pack([head | tail], [head])]

          [head | tail] ->
            [current_pack | [head | pack(tail)]]
        end
    end
  end
end

IO.inspect(ListManipulation.pack([1], [2, 2]),
  label: "pack 1..9"
)

IO.inspect(ListManipulation.pack([]), label: "pack []")
IO.inspect(ListManipulation.pack([1]), label: "pack 1")

IO.inspect(ListManipulation.pack([1, 2, 3, 4, 4, 4, 5]),
  label: "pack 1..9"
)

IO.inspect(ListManipulation.pack([1, 2, 2, 2, 3, 3, 4, 5, 6, 6, 6, 1, 2, 1, 1, 9]),
  label: "pack 1..9"
)

IO.inspect(ListManipulation.pack([1, 1, 1, 1, 1, 1, 1]), label: "pack 1")
IO.inspect(ListManipulation.pack([1, 2, 2, 3, 3, 3, 4, 4, 4]), label: "pack 1..4")

IO.inspect(ListManipulation.compress([]), label: "compress []")
IO.inspect(ListManipulation.compress([1]), label: "compress 1")

IO.inspect(ListManipulation.compress([1, 2, 2, 2, 3, 3, 4, 5, 6, 6, 6, 1, 2, 1, 1, 9]),
  label: "compress 1"
)

IO.inspect(ListManipulation.compress([1, 1, 1, 1, 1, 1, 1]), label: "compress 1")
IO.inspect(ListManipulation.compress([1, 2, 2, 3, 3, 3, 4, 4, 4]), label: "compress 1..4")

IO.inspect(ListManipulation.flatten(1), label: "flatten 1")
IO.inspect(ListManipulation.flatten([1]), label: "flatten 1")
IO.inspect(ListManipulation.flatten([[1]]), label: "flatten 1")
IO.inspect(ListManipulation.flatten([1, 2]), label: "flatten 1..2")
IO.inspect(ListManipulation.flatten([[1, 2], 3]), label: "flatten 1..3")

IO.inspect(ListManipulation.flatten([1, 2, 3]), label: "flatten 1..3")

IO.inspect(ListManipulation.flatten([[[[1]]], [2, 2], [[[3, [4]]]]]), label: "flatten 1..4")

IO.inspect(ListManipulation.flatten([[[1]], [2, 3, [4, 5, [6, [[7]]]]], 8, [[[9]]]]),
  label: "flatten 1..9"
)

IO.inspect(ListManipulation.flatten([[[1]], [2, 3, [4, 5, [6, [[7]]]]], 8, [[[9]]]]),
  label: "flatten 1..9"
)

IO.inspect(ListManipulation.palindrome?([1, 2, 3, 2, 1]), label: "yes palindrome")
IO.inspect(ListManipulation.palindrome?([1, 2, 3, 3, 2, 1]), label: "yes palindrome")
IO.inspect(ListManipulation.palindrome?([1, 2, 3, 3, 5, 2, 1]), label: "no palindrome")
IO.inspect(ListManipulation.palindrome?([]), label: "yes empty palindrome")
IO.inspect(ListManipulation.palindrome?([1]), label: "yes one item palindrome")
IO.inspect([1 | [2 | [3 | [4 | []]]]], label: "empty")
IO.inspect(ListManipulation.list_length([]), label: "empty")
IO.inspect(ListManipulation.list_length(["a", [3, 4], "popopop", 4, 5, 6]), label: "6 items")

IO.inspect(ListManipulation.element_at(["a", [3, 4], "popopop", 4, 5, 6], 3), label: "index3 = 4")
IO.inspect(ListManipulation.element_at(["a", [3, 4], "popopop", 4, 5, 6], "x"), label: "not int")

IO.inspect(ListManipulation.element_at(["a", [3, 4], "popopop", 4, 5, 6], 100),
  label: "k too big"
)

IO.inspect(ListManipulation.element_at(["a", [3, 4], "popopop", 4, 5, 6], 0), label: "first: 'a'")
IO.inspect(ListManipulation.element_at(["a", [3, 4], "popopop", 4, 5, 6], 5), label: "last 6")

IO.inspect(ListManipulation.reverse_list(String.graphemes("abcdef")), label: "abcdef")
IO.inspect(ListManipulation.reverse_list([1, 2, 3, 4, 5]), label: "1,2,3,4,5")
