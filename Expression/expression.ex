defmodule Expression do
  @type literal() :: {:num, number()}
    | {:var, atom()}
    | {:q, number(), number()}

  @type expr() :: {:add, expr(), expr()}
    | {:sub, expr(), expr()}
    | {:mul, expr(), expr()}
    | {:div, expr(), expr()}
    | literal()

  def eval({:num, n}, _) do n end
  def eval({:q, n, d}, _) do {:q, n, d} end
  def eval({:var, a}, env) do Map.fetch!(env, a) end
  def eval({:add, e1, e2}, env) do
    add(eval(e1, env), eval(e2, env))
  end
  def eval({:sub, e1, e2}, env) do
    sub(eval(e1, env), eval(e2, env))
  end
  def eval({:mul, e1, e2}, env) do
    mul(eval(e1, env), eval(e2, env))
  end
  def eval({:div, e1, e2}, env) do
    divs(eval(e1, env), eval(e2, env))
  end

  # Add function
  def add({:q, n1, d1}, {:q, n2, d2}) do
    reduce({:q, (n1*d2) + (n2*d1), d1*d2})
  end
  def add({:q, n, d}, val) do
    reduce({:q, n + (val * d), d})
  end
  def add(val, {:q, n, d}) do
    reduce({:q, n + (val * d), d})
  end
  def add(val1, val2) do
    val1 + val2
  end

  # Subtraction function
  def sub({:q, n1, d1}, {:q, n2, d2}) do
    reduce({:q, (n1*d2) - (n2*d1), d1*d2})
  end
  def sub({:q, n, d}, val) do
    reduce({:q, n - (val*d), d})
  end
  def sub(val, {:q, n, d}) do
    reduce({:q, (val*d) - n, d})
  end
  def sub(val1, val2) do
    val1 - val2
  end

  # Multiplication function
  def mul({:q, n1, d1}, {:q, n2, d2}) do
    reduce({:q, n1*n2, d1*d2})
  end
  def mul(val, {:q, n, d}) do
    reduce({:q, n * val, d})
  end
  def mul({:q, n, d}, val) do
    reduce({:q, n * val, d})
  end
  def mul(val1, val2) do
    val1 * val2
  end

  # Division function
  def divs({:q, n1, d1}, {:q, n2, d2}) do
    reduce({:q, n1*d2, n2*d1})
  end
  def divs(val, {:q, n, d}) do
    reduce({:q, val*d, n})
  end
  def divs({:q, n, d}, val) do
    reduce({:q, n, d*val})
  end
  def divs(val1, val2) do
    reduce({:q, val1, val2})
  end

  def reduce({:q, n, d}) do {:q, div(n, Integer.gcd(n, d)), div(d, Integer.gcd(n, d))} end

  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, v}) do "#{v}" end
  def pprint({:add, e1, e2}) do "#{pprint(e1)} + #{pprint(e2)}" end
  def pprint({:sub, e1, e2}) do "#{pprint(e1)} - #{pprint(e2)}" end
  def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end
  def pprint({:div, e1, e2}) do "#{pprint(e1)} / #{pprint(e2)}" end
  def pprint({:q, e1, e2}) do "#{pprint(e1)}/#{pprint(e2)}" end
  def pprint(n) do "#{n}" end

  def test_add do
    n1 = {:var, :x}
    n2 = {:q, 1, 2}
    e = {:add, n1, n2}
    env = Map.new([{:z, 15}, {:y, 10}, {:x, 5}])
    e = Expression.eval(e, env)
    IO.inspect(e)

    IO.write("expression: #{pprint(e)}\n")
  end

  def test_sub do
    n1 = {:num, 5}
    n2 = {:q, 1, 2}
    e = {:sub, n1, n2}
    env = Map.new([{:z, 15}, {:y, 10}, {:x, 5}])
    e = Expression.eval(e, env)
    IO.inspect(e)

    IO.write("expression: #{pprint(e)}\n")
  end

  def test_mul do
    n1 = {:num, 10}
    n2 = {:q, 1, 2}
    e = {:mul, n1, n2}
    env = Map.new([{:z, 15}, {:y, 10}, {:x, 5}])
    e = Expression.eval(e, env)

    IO.write("expression: #{pprint(e)}\n")
  end

  def test_div do
    e = {:div, {:q, 1, 2}, {:num, 2}}
    env = Map.new([{:y, 10}, {:x, 5}])
    e = Expression.eval(e, env)

    IO.write("expression: #{pprint(e)}\n")
  end
end
