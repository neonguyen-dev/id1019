defmodule Springs2 do

  def test() do
    parsed = parse_rows()
    IO.inspect(parsed)
    parsed = Enum.map(parsed, fn x ->
      mul_desc(elem(x, 0), elem(x, 1), 5) end)
    ans = Enum.map(parsed, fn x ->
      search(elem(x, 0), elem(x, 1), Map.new()) end)
    Enum.reduce(ans, 0, fn {x, y}, acc -> x+acc end)
  end

    def parse_rows() do
      File.read!("input.txt")
      |>
      String.split("\n") |>
      Enum.map(fn(x) -> String.split(x, " ") end) |>
      Enum.map(fn x ->
        status = List.first(x)
        sequence = String.split(List.last(x), ",")
        {status, sequence}
        end) |>
      Enum.map(fn x ->
        stat = elem(x, 0)
        seq = elem(x, 1)
        charStatus = String.to_charlist(stat)
        numSequence = Enum.map(seq, fn x -> {x, _} = Integer.parse(x); x end)
        {charStatus, numSequence}
        end)
    end

    def check(springs, seq, mem) do
      case Map.get(mem, {springs, seq}) do
        nil ->
          {count, newMem} = search(springs, seq, mem)
          {count, Map.put(newMem, {springs, seq}, count)}
        result ->
          {result, mem}
      end
    end

    def search([], [], mem) do {1, mem} end
    def search([], seq, mem) do {0, mem} end
    def search([35|_], [], mem) do {0, mem} end
    def search([46|rest], seq, mem) do
      check(rest, seq, mem)
    end
    def search([35|springs], [n|seq], mem) do
      case damaged(springs, n-1) do
        {:ok, rest} ->
          check(rest, seq, mem)
        :error ->
          {0, mem}
      end
    end
    def search([63|springs], seq, mem) do
      {c1, mem} = search([46|springs], seq, mem)
      {c2, mem} = search([35|springs], seq, mem)
      {c1+c2, mem}
    end

    def damaged([], 0) do {:ok, []} end
    def damaged([35|_], 0) do :error end
    def damaged([_|springs], 0) do {:ok, springs} end
    def damaged([46|_], n) do :error end
    def damaged([_|springs],n) do
      damaged(springs, n-1)
    end
    def damaged(_, _) do
      :error
    end

    def mul_desc(wells, seq, 1) do {wells, seq} end
    def mul_desc(wells, seq, n) do
      {copy_wells, copy_seq} = mul_desc(wells, seq, n-1)
      wells = wells++[63|copy_wells]
      seq = seq++copy_seq
      {wells, seq}
    end

  end
