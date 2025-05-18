defmodule E1 do
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
end

IO.inspect(E1.last(3), label: "should be an error, not a list")
IO.inspect(E1.last([]), label: "should be an error, empty list")
IO.inspect(E1.last(["a"]), label: "should return the string a")
IO.inspect(E1.last([1, 2, 3, 4, 5]), label: "should return 5")
IO.inspect(E1.last([1, [2], 3, [4, 5]]), label: "should return [4,5]")
