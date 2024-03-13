defmodule Ranges2 do
  def test() do
    solve(parse(File.read!("sample.txt")))
  end

  def extend(seeds) do
    seeds
    |> Enum.chunk_every(2)
    |> Enum.map(fn [head | [tail]] -> Range.new(head, head + tail - 1, 1) end)
  end

  def solve({seeds, maps}) do
    [head | tail] = seeds
    |> extend()
    #|> Enum.map(fn seed -> lookup_seed_location(seed, maps) end)
    #|> Enum.min()
  end

  def lookup_seed_location(seed, maps) do
    [
      :seed_to_soil,
      :soil_to_fertilizer,
      :fertilizer_to_water,
      :water_to_light,
      :light_to_temperature,
      :temperature_to_humidity,
      :humidity_to_location
    ]
    |> Enum.reduce(seed, fn(type, input) -> perform_mapping(input, type, maps) end)
  end

  def perform_mapping(input, type, maps) do
    {input, type, maps}

    Enum.find_value(maps[type], input, fn {
                                            input_range = input_start.._,
                                            output_start.._
                                          } ->
      if input in input_range do
        offset = input - input_start
        output_start + offset
      end
    end)
  end

  def parse(input) do
    [seeds | maps] =
    input
      |> String.split("\n\n")
    seeds = seeds
      |> String.trim("seeds: ")
      |> String.split(" ")
      |> Enum.map(fn number -> {nr, _} = Integer.parse(number)
        nr
      end)
    maps = maps
      |> Enum.map(fn map -> [[name] | mappings] = String.split(map, "\n")
        |> Enum.map(fn map -> String.trim(map, " map:") end)
        |> Enum.map(fn map -> String.split(map, " ") end)
        name = name
          |> String.replace("-", "_")
          |> String.to_atom()
        mappings = mappings
          |> Enum.map(fn mapping ->
            [output, input, length] = mapping
              |> Enum.map(fn number -> {nr, _} = Integer.parse(number)
              nr
            end)
            {Range.new(input, input + length - 1, 1), Range.new(output, output + length - 1, 1)}
          end)
        {name, mappings}
    end)
    {seeds, maps}
  end
end
