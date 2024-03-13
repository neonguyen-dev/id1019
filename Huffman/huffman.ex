defmodule Huffman do
  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)

    case :unicode.characters_to_list(binary, :utf8) do
    {:incomplete, list, _} ->
      list
    list ->
      list
    end
  end

  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text() do
    'this is something that we should encode'
  end

  def benchmark() do
    {time, _} = :timer.tc(fn -> test() end)
    time
  end

  def test do
    {timeSample, sample} = :timer.tc(fn ->read("kallocain.txt") end)
    {timeTree, tree} = :timer.tc(fn ->tree(sample) end)
    {timeEncodeTable, encode} = :timer.tc(fn ->encode_table(tree) end)
    {timeText, text} = :timer.tc(fn ->read("kallocain.txt") end)
    {timeEncode, seq} = :timer.tc(fn ->encode(text, encode) end)
    {timeDecode, _} = :timer.tc(fn ->decode(seq, encode) end)
    #{:ok, file} = File.open("output.txt", [:write, {:encoding, :utf8}])
    #IO.write(file, List.to_string(decode(seq, encode)))
    #:ok = File.close(file)
    #decode = decode_table(tree)
    #text = text()
    #text = sample()
    #FileWriter.write_to_file("output.txt", List.to_charlist(text))
    {timeTree, timeEncodeTable, timeEncode, timeDecode}
  end

  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  def encode_table(tree) do
    depth_first(tree, [])
  end

  def depth_first({left, right}, list) do
    depth_first(left, [0 | list]) ++ depth_first(right, [1 | list])
  end
  def depth_first(leaf, list) do
    [{leaf, Enum.reverse(list)}]
  end

  def decode_table(tree) do

  end

  def encode(text, table) do
    List.flatten(Enum.map(text, fn c1 ->
      {_, path} = Enum.find(table, fn {c2, _} -> c1 == c2 end)
      path
    end))
  end

  def decode([], _) do
    []
  end
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end
  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {char, _} ->
        {char, rest}
      nil ->
        decode_char(seq, n + 1, table)
    end
  end

  def freq(sample) do
    sample
    |> Enum.frequencies()
    |> Enum.sort(fn ({_, f1}, {_, f2}) -> f1 < f2 end)
    #|> Enum.reduce(0, fn {_, f}, acc -> f + acc end)
  end

  def huffman([{tree, _}]) do
    tree
  end
  def huffman([{a, af}, {b, bf} | rest]) do
    #IO.inspect({{a, b}, af + bf})
    huffman(insert({{a, b}, af + bf}, rest))
  end

  def insert({a, af}, []) do
    [{a, af}]
  end
  def insert({a, af}, [{b, bf} | rest]) do
    case af < bf do
      true ->
        [{a, af}, {b, bf} | rest]
      _ ->
        [{b, bf} | insert({a, af}, rest)]
    end
  end
end
