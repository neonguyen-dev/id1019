defmodule HighOrder do
  # The length of the list
  def length(list) do
    reduce(list, 0, fn _, acc -> acc + 1 end)
  end

  # List of all even number
  def even(list) do
    filter(list, fn x -> rem(x, 2) == 0 end)
  end

  # List where each element of the given list has been incremented by a value.
  def inc(list, value) do
    map(list, fn x -> x + value end)
  end

  # The sum of all values of the given list.
  def sum(list) do
    reduce(list, 0, fn x, acc -> acc + x end)
  end

  # A list where each element of the given list has been decremented by a value.
  def dec(list, value) do
    map(list, fn x -> x - value end)
  end

  # A list where each element of the given list has been multiplied by a value.
  def mul(list, value) do
    map(list, fn x -> value * x end)
  end

  # A list of all odd number.
  def odd(list) do
    filter(list, fn x -> rem(x, 2) == 1 end)
  end

  # A list with the result of taking the reminder of dividing the original by some integer.
  def rems(list, value) do
    map(list, fn x -> rem(x, value) end)
  end

  # The product of all values of the given list
  def prod(list) do
    reduce(list, 1, fn x, acc -> acc * x end)
  end

  # A list of all numbers that are evenly divisible by some number.
  def div(list, value) do
    filter(list, fn x -> rem(x, value) == 0 end)
  end

  def test(list, value) do
    sum(map(filter(list, fn x -> (x < value) end), fn x -> x*x end))
  end

  def map([], _) do [] end
  def map([h|t], f) do
    [f.(h) | map(t, f)]
  end

  def reduce([], acc, _) do acc end
  def reduce([head | tail], acc, f) do
    reduce(tail, f.(head, acc), f)
  end

  def filter([], _) do [] end
  def filter([head|tail], f) do
    if f.(head) do
      [head | filter(tail, f)]
    else
      filter(tail, f)
    end
  end
end
