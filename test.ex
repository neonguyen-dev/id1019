defmodule Test do

  # Compute the double of number
  def double(n) do
    2 * n
  end

  # Computes celsius with a value of fahrenheit
  def fahrenheit_to_celsius(f) do
    (f-32)/1.8
  end

  def rectangle(l,s) do
    l * s
  end

  def square(s) do
    rectangle(s,s)
  end

  def circle(r) do
    :math.pi*r*r
  end

  def product(m, n) do
    if m == 0 do
      0
    else
      n + product(m - 1, n)
    end
  end



end
