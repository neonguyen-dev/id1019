defmodule Range do
  def test() do
    File.read!("sample.txt") |>
    parse() |>
    locations() |>
    Enum.reduce(:inf, fn(x, acc) -> min(x, acc) end)
  end

  def locations({seeds, maps}) do
    Enum.map(seeds, fn(seed) -> transform(maps, seed) end)
  end

  def transform(maps, seed) do
    Enum.reduce(maps, seed, fn(map, sofar) -> transf(map, sofar) end)
  end

  def transf(trs, nr) do
    case Enum.filter(trs, fn({:tr, _, from, length}) ->
      (nr >= from) and (nr <= (from+length-1))
    end) do
    [] -> nr
    [{:tr, to, from, _}] ->
      (nr - from) + to
    end
  end

  def parse(descr) do
    [seeds | maps] = String.split(descr, "\n\n")
    [_, seeds] = String.split(seeds, ":")
    seeds = String.split(String.trim(seeds), " ")
    seeds = Enum.map(seeds, fn x -> {nr,_} = Integer.parse(x); nr end)
    IO.puts("seeds")
    IO.inspect(seeds)
    maps = Enum.map(maps, fn (map) ->
      [_, map] = String.split(map, ":")
      map = String.split(String.trim(map), "\n")
      Enum.map(map, fn(mp) ->
       [from, to, length] =  Enum.map(String.split(mp, " "), fn x ->
          {nr, _} = Integer.parse(x); nr end)
       {:tr, from, to, length}
      end)
    end)
    printThis = {seeds, maps}
    IO.inspect(printThis)
  end
end
