defmodule E2 do
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
end

IO.inspect(E2.last2(3), label: "should be an error, not a list")
IO.inspect(E2.last2([]), label: "should be an error, empty list")
IO.inspect(E2.last2(["a"]), label: "should return error")
IO.inspect(E2.last2([1, 2, 3, 4, 5]), label: "should return [4,5]")
IO.inspect(E2.last2([1, [2], 3, [4, 5]]), label: "should return [3,[4,5]")
