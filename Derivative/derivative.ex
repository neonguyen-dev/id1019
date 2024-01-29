defmodule Derivative do
  @type literal() :: {:num, number()} | {:var, atom()}
  @type expr() :: {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:exp, expr(), {:num, number()}}
  | {:ln, expr()}
  | {:sin, expr()}
  | {:cos, expr()}
  | literal()

  def test() do
    #a = {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}
    a ={:exp, {:sin, {:mul, {:num, 2}, {:var, :x}}}, {:num,-1}}
    #a = {:exp, {:var, :x}, {:num, 2}}
    b = deriv(a, :x)
    c = simplify(b)
    IO.write("Expression: #{pprint(a)} \n")
    IO.write("Derivative: #{pprint(b)} \n")
    #IO.inspect(a)
    #IO.inspect(b)
    #IO.inspect(c)
    IO.write("Simplified: #{pprint(c)} \n")
  end

  def test1() do
    e = {:add,
          {:mul, {:num, 2}, {:var, :x}},
          {:num, 4}
        }
    d = deriv(e, :x)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    :ok
  end

  def test2() do
    e = {:add,
          {:exp, {:var, :x}, {:num, 3}},
          {:num, 4}
        }
    d = deriv(e, :x)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    :ok
  end

  def test3() do
    e = {:add,
          {:ln, {:add, {:mul, {:exp, {:var, :x}, {:num, 2}}, {:num, 3}}, {:num, 5}}},
          {:num, 4}
        }
    d = deriv(e, :x)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    :ok
  end

  def test4() do
    e = {:add,
          {:exp, {:exp, {:var, :x}, {:num, 2}}, {:num, -1}},
          {:num, 4}
        }
    d = deriv(e, :x)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    :ok
  end

  def test5() do
    e = {:add,
          {:sin, {:var, :x}},
          {:num, 4}
        }
    d = deriv(e, :x)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    :ok
  end

  def deriv({:num, _}, _) do {:num, 0} end

  def deriv({:var, v}, v) do {:num, 1} end

  def deriv({:var, _}, _) do {:num, 0} end

  def deriv({:mul, e1, e2}, v) do
    {:add, {:mul, deriv(e1,v), e2}, {:mul, deriv(e2,v), e1}}
  end

  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)}
  end

  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul, {:num, n}, {:exp, e, {:num, n - 1}}},
      deriv(e, v)}
  end

  def deriv({:ln, e}, v) do
    {:mul,{:exp, e, {:num, -1}},
      deriv(e,v)}
  end

  def deriv({:sin, e}, v) do
    {:mul, {:cos, e},
      deriv(e, v)}
  end
  def deriv(:cos, e, v) do
    {:mul, {:num, -1}, {:mul, {:sin, e}, deriv(e,v)}}
  end

  #Print
  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, v}) do "#{v}" end
  def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
  def pprint({:mul, e1, e2}) do "(#{pprint(e1)}*#{pprint(e2)})" end
  def pprint({:exp, e1, n}) do "([#{pprint(e1)}]^#{pprint(n)})" end
  def pprint({:ln, e}) do "(ln[#{pprint(e)}])" end
  def pprint({:sin, e}) do "(sin[#{pprint(e)}])" end
  def pprint({:cos, e}) do "(cos[#{pprint(e)}])" end

  #Simplify add
  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def simplify_add({:var, v}, {:var, v}) do {:mul, {:num, 2}, {:var, v}} end
  def simplify_add(e1, e2) do {:add, e1, e2} end

  #Simplify mul
  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end

  #Simplify exp
  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp(e, {:num, 1}) do e end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end

  def simplify_sin(e) do {:sin, e} end
  def simplify_cos(e) do {:cos, e}end

  #Simplify
  def simplify({:num, n}) do {:num, n} end
  def simplify({:var, v}) do {:var, v} end
  def simplify({:add, e1, e2}) do simplify_add(simplify(e1), simplify(e2)) end
  def simplify({:mul, e1, e2}) do simplify_mul(simplify(e1), simplify(e2)) end
  def simplify({:exp, e, n}) do simplify_exp(simplify(e), simplify(n)) end
  def simplify({:sin, e}) do simplify_sin(simplify(e)) end
  def simplify({:cos, e}) do simplify_cos(simplify(e))end
end
