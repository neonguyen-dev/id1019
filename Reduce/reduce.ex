defmodule Reduce do
  import Kernel, except: [length: 1, div: 2]

  # The length of the list
  def length([]) do
    0
  end
  def length([_ | tail]) do
    1 + length(tail)
  end

  # List of all even number
  def even([]) do
    []
  end
  def even([head | tail]) do
    case rem(head, 2) do
      0 ->
        [head | even(tail)]
      _ ->
        even(tail)
    end
  end

  # List where each element of the given list has been incremented by a value.
  def inc([], _) do
    []
  end
  def inc([head | tail], value) do
    [head + value | inc(tail, value)]
  end

  # The sum of all values of the given list.
  def sum([]) do
    0
  end
  def sum([head | tail]) do
    head + sum(tail)
  end

  # A list where each element of the given list has been decremented by a value.
  def dec([], _) do
    []
  end
  def dec([head | tail], value) do
    [head - value | dec(tail, value)]
  end

  # A list where each element of the given list has been multiplied by a value.
  def mul([], _) do
    []
  end
  def mul([head | tail], value) do
    [head * value | mul(tail, value)]
  end

  # A list of all odd number.
  def odd([]) do
    []
  end
  def odd([head | tail]) do
    case rem(head, 2) do
      1 ->
        [head | odd(tail)]
      _ ->
        odd(tail)
    end
  end

  # A list with the result of taking the reminder of dividing the original by some integer.
  def rems([], _) do
    []
  end
  def rems([head | tail], value) do
    [rem(head, value) | rems(tail, value)]
  end

  # The product of all values of the given list
  def prod([]) do
    1
  end
  def prod([head | tail]) do
    head * prod(tail)
  end

  # A list of all numbers that are evenly divisible by some number.
  def div([], _) do
    []
  end
  def div([head | tail], value) do
    case rem(head, value) do
      0 ->
        [head | div(tail, value)]
      _ ->
        div(tail, value)
    end
  end
end
