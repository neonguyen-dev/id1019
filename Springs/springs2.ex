defmodule Springs2 do
  def test() do
    IO.inspect(solve(File.read!("input.txt") , 1))
    IO.inspect(solve(File.read!("input.txt") , 2))
    IO.inspect(solve(File.read!("input.txt") , 3))
    #solve(".??..??...?##. 1,1,3", 5)
  end

  def solve(input, n) do
    :timer.tc(fn () -> parse(input)
      |> Enum.map(fn {springs, integers} ->
        extend(springs, integers, n) end)
      |> Enum.map(fn {springs , integers} ->
        {possible, _} = check({springs, integers}, [], Map.new())
        possible
      end)
      |> Enum.sum() end)
  end

  def extend(springs, integers, n) do
    {List.flatten(Enum.intersperse(List.duplicate(springs, n), ??)),
    List.flatten(List.duplicate(integers, n))}
  end

  def parse(input) do
    input
      |> String.split("\n")
      |> Enum.map(fn string -> String.trim(string) end)
      |> Enum.map(fn string ->
        [springs | integers] = String.split(string, [" ", ","])
        springs = springs
          |> String.to_charlist
          {springs, Enum.map(integers, fn integer -> String.to_integer(integer) end)}
      end)
  end

  def check({springs, integers}, possible, memory) do
    case Map.get(memory, {springs, integers}) do
      nil ->
        {count, newMemory} = count({springs, integers}, possible, memory)
        {count, Map.put(newMemory, {springs, integers}, count)}
      result ->
        {result, memory}
    end
  end

  def count({[],[]}, _, memory) do
    {1, memory}
  end
  def count({[], [0]}, _, memory) do
    {1, memory}
  end
  def count({[], _}, _, memory) do {0, memory} end
  def count({[?# | _], []}, _, memory) do {0, memory} end
  def count({[?. | springs], []}, possible, memory) do
    check({springs, []}, [?. | possible], memory)
  end
  def count({[?? | springs], []}, possible, memory) do
    check({[?. | springs], []}, possible, memory)
  end
  def count({[spring | springs], [integer | integers]}, possible, memory) do
    case {spring, integer > 0} do
      {?., true} ->
        case possible do
          [?# | _] ->
            {0, memory}
          _ ->
            check({springs, [integer | integers]}, [?. | possible], memory)
        end
      {?., false} ->
        check({springs, integers}, [?. | possible], memory)
      {?#, true} ->
        check({springs, [integer - 1 | integers]}, [?# | possible], memory)
      {?#, false} -> {0, memory}
      {??, _} ->
        {count1, memory} = check({[?. | springs], [integer | integers]}, possible, memory)
        {count2, memory} = check({[?# | springs], [integer | integers]}, possible, memory)
        {count1 + count2, memory}
    end
  end
end
