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
  def eval({:var, a}, env) do Map.fetch(env, a) end
  def eval({:add, e1, e2}, env) do
    add(eval(e1, env), eval(e2, env))
  end
  def eval({:sub, e1, e2}, env) do
    sub(eval(e1, env), eval(e2, env))
  end
  def eval({:mul, e1, e2}, env) do
    mul(eval(e1, env), eval(e2))
  end
  def eval({:div, e1, e2}, env) do
    div(eval(e1, env), eval(e2, env))
  end


  def add({:num, n1}, {:num, n2}) do
    n1 + n2
  end
  def add({:q, n1, d1}, {:q, n2, d2}) do

  end


  def mul({:q, n1, d1}, {:q, n2, d2}) do

  end


end
