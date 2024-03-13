defmodule Morse do
  def test do
    table = encode_table(MorseCode.tree(), Map.new(), [])
    #signal = base()
    #signal = rolled()
    #signal = name()
    IO.inspect(MorseCode.base())
    IO.inspect(decode(MorseCode.base(), MorseCode.tree()))
    IO.inspect(decode(MorseCode.rolled(), MorseCode.tree()))
    IO.inspect(decode(MorseCode.name(), MorseCode.tree()))
    encode('all your base are belong to us', table)
  end

  def decode(str) do
    decode(str, MorseCode.tree())
  end
  def decode([], _) do
    []
  end
  def decode(signal, tree) do
    {char, rest} = decode_char(signal, tree)
    [char | decode(rest, tree)]
  end

  def decode_char([], {:node, character,_,_}) do
    {character, []}
  end
  def decode_char([head | tail], {:node, character, long, short}) do
    case {head, character != :na} do
      {?\s, true} ->
        {character, tail}
      {?\s, false} ->
        decode_char(tail, {:node, character, long, short})
      {?-, _} ->
        decode_char(tail, long)
      {?., _} ->
        decode_char(tail, short)
    end
  end

  def encode(str) do
    table = encode_table(MorseCode.tree(), Map.new(), [])
    encode(str, table)
  end

  def encode(str, table) do
    str
    |> Enum.map(fn char -> Map.get(table, char) end)
    |> Enum.join(" ")
    |> String.to_charlist()
  end

  def encode_table(nil, map, _) do
    map
  end
  def encode_table({:node, :na, long, short}, map, list) do
    map = encode_table(long, map, list ++ '-')
    encode_table(short, map, list ++ '.')
  end
  def encode_table({:node, character, nil, nil}, map, list) do
    Map.put(map, character, list)
  end
  def encode_table({:node, character, long, nil}, map, list) do
    map = encode_table(long, map, list ++ '-')
    Map.put(map, character, list)
  end
  def encode_table({:node, character, nil, short}, map, list) do
    map = encode_table(short, map, list ++ '.')
    Map.put(map, character, list)
  end
  def encode_table({:node, character, long, short}, map, list) do
    map = encode_table(long, map, list ++ '-')
    map = encode_table(short, map, list ++ '.')
    Map.put(map, character, list)
  end
end
