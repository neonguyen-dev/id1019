defmodule Springs do
  def test() do
    solve(File.read!("input.txt"), 5)
  end

  def solve(input, n) do
    :timer.tc(fn () -> parse(input)
      |> Enum.map(fn {springs, integers} -> extend(springs, integers, n) end)
      |> Enum.map(fn {springs , integers} -> count({springs, integers}, []) end)
      |> Enum.sum() end)
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

  def extend(springs, integers, n) do
    {List.flatten(Enum.intersperse(List.duplicate(springs, n), ??)),
    List.flatten(List.duplicate(integers, n))}
  end

  def count({[],[]}, _) do 1 end
  def count({[], [0]}, _) do 1 end
  def count({[], _}, _) do 0 end
  def count({[?# | _], []}, _) do 0 end
  def count({[?. | springs], []}, possible) do
    count({springs, []}, [?. | possible])
  end
  def count({[?? | springs], []}, possible) do
    count({[?. | springs], []}, possible)
  end

  def count({[spring | springs], [integer | integers]}, possible) do
    case {spring, integer > 0} do
      {?., true} ->
        case possible do
          [?# | _] ->
            0
          _ ->
            count({springs, [integer | integers]}, [?. | possible])
        end
      {?., false} ->
        count({springs, integers}, [?. | possible])
      {?#, true} ->
        count({springs, [integer - 1 | integers]}, [?# | possible])
      {?#, false} -> 0
      {??, _} ->
        count({[?. | springs], [integer | integers]}, possible) +
        count({[?# | springs], [integer | integers]}, possible)
    end
  end
end
