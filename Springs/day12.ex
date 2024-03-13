defmodule AoC do
  def test() do
    part1("???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1")
  end
  def part1(input) do
    parse(input)
    |> Enum.map(&possible_arrangements/1)
    |> Enum.sum
  end

  def possible_arrangements({springs, numbers}) do
    possibilities(springs)
    |> Enum.filter(&(valid?(&1, numbers)))
    |> Enum.count |> tap(&IO.puts(&1))
  end

  def possibilities(springs, possible \\ [[]])
  def possibilities([], possible) do
    IO.inspect(possible)
    possible
  end
  def possibilities([:unknown | springs], possible) do
    variant1 = Enum.map(possible, fn x -> x ++ [:damaged] end)
    variant2 = Enum.map(possible, fn x -> x ++ [:operational] end)
    possibilities(springs, variant1 ++ variant2)
  end
  def possibilities([:damaged | springs], possible) do
    variant1 = Enum.map(possible, fn x -> x ++ [:damaged] end)
    possibilities(springs, variant1)
  end
  def possibilities([:operational | springs], possible) do
    variant2 = Enum.map(possible, fn x -> x ++ [:operational] end)
    possibilities(springs, variant2)
  end

  def valid?(springs, numbers) do
    springs
    |> Enum.chunk_by(&(&1))
    |> Enum.reject(fn s -> Enum.all?(s, &(&1 == :operational)) end)
    |> Enum.map(&Enum.count/1)
    |> Kernel.==(numbers)
  end
  def parse(raw_records) do
    raw_records
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(raw_line) do
    [raw_chars, raw_numbers] = String.split(raw_line)

    numbers = raw_numbers
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    springs = raw_chars
      |> String.graphemes
      |> Enum.map(&(case &1 do
                     "." -> :operational
                     "#" -> :damaged
                     "?" -> :unknown
                    end))

    {springs, numbers}
  end
end
