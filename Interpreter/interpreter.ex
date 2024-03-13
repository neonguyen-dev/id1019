defmodule Prgm do
  def append() do
    {[:x, :y],
      [{:case, {:var, :x},
        [{:clause, {:atm, []}, [{:var, :y}]},
          {:clause, {:cons, {:var, :hd}, {:var, :tl}},
          [{:cons,
            {:var, :hd},
            {:apply, {:fun, :append}, [{:var, :tl}, {:var, :y}]}}]
        }]
      }]
    }
  end
end

defmodule Env do
  def new() do
    []
  end

  def add(id, str, env) do
    [{id, str} | env]
  end

  def lookup(_, []) do
    nil
  end
  def lookup(id, [{id, str}|_]) do
    {id, str}
  end
  def lookup(id, [_|t]) do
    lookup(id, t)
  end

  def remove(ids, env) do
    Enum.reject(env, fn{id,_} -> id in ids end)
  end

  def closure(ids, env) do
    filtered = Enum.reject(env, fn{id,_} -> id not in ids end)

    if(length(filtered) == length(ids)) do
      filtered
    else
      :error
    end
  end

  def args(ids, strs, env) do
    List.zip([ids, strs]) ++ env
  end
end

defmodule Eager do
  def eval_expr({:atm, id}, _) do {:ok, id} end
  def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
      nil ->
        :error
      {_, str} ->
        {:ok, str}
    end
  end
  def eval_expr({:cons, head_expr, tail_expr}, env) do
    case eval_expr(head_expr, env) do
      :error ->
        :error
      {:ok, head} ->
        case eval_expr(tail_expr, env) do
          :error ->
            :error
          {:ok, ts} ->
            {:ok, {head, ts}}
        end
    end
  end
  def eval_expr({:case, expr, cls}, env) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, str} ->
        eval_cls(cls, str, env)
    end
  end
  def eval_expr({:lambda, par, free, seq}, env) do
    case Env.closure(free, env) do
      :error ->
        :error
      closure ->
        {:ok, {:closure, par, seq, closure}}
    end
  end
  def eval_expr({:apply, expr, args}, env) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, {:closure, par, seq, closure}} ->
        case eval_args(args, env) do
          :error ->
            :error
          {:ok, strs} ->
            env = Env.args(par, strs, closure)
            eval_seq(seq, env)
        end
    end
  end
  def eval_expr({:fun, id}, _) do
    {par, seq} = apply(Prgm, id, [])
    {:ok, {:closure, par, seq, Env.new()}}
  end

  def eval_match(:ignore, _, env) do
    {:ok, env}
  end
  def eval_match({:atm, id}, id, env) do
    {:ok, env}
  end
  def eval_match({:var, id}, str, env) do
    case Env.lookup(id, env) do
      nil ->
        {:ok, Env.add(id, str, env)}
      {_, ^str} ->
        {:ok, env}
      {_, _} ->
        :fail
    end
  end
  def eval_match({:cons, hp, tp}, {hs, ts}, env) do
    case eval_match(hp, hs, env) do
      :fail ->
        :fail
      {:ok, env} ->
        eval_match(tp, ts, env)
    end
  end
  def eval_match(_, _, _) do
    :fail
  end

  def extract_vars(ptr) do
    case ptr do
      :ignore ->
        []
      {:atm, _} ->
        []
      {:var, id} ->
        [id]
      {:cons, head, tail} ->
        extract_vars(head) ++ extract_vars(tail)
    end
  end

  def eval_scope(ptr, env) do
    Env.remove(extract_vars(ptr), env)
  end
  def eval_seq([exp], env) do
    eval_expr(exp, env)
  end
  def eval_seq([{:match, ptr, expr} | tail], env) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, str} ->
        env = eval_scope(ptr, env)
        case eval_match(ptr, str, env) do
          :fail ->
            :error
          {:ok, env} ->
            eval_seq(tail, env)
      end
    end
  end

  def eval(seq) do
    case eval_seq(seq, Env.new()) do
      :error ->
        :error
      {:ok, str} ->
        {:ok, str}
    end
  end

  def eval_cls([], _, _) do
    :error
  end
  def eval_cls([{:clause, ptr, seq} | cls], str, env) do
    case eval_match(ptr, str, env) do
      :fail ->
        eval_cls(cls, str, env)
      {:ok, env} ->
        eval_seq(seq, env)
    end
  end

  def eval_args(args, env) do
    eval_args(args, env, [])
  end
  def eval_args([],_,strs) do {:ok, Enum.reverse(strs)} end
  def eval_args([expr | args], env, strs) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, str} ->
        eval_args(args, env, [str | strs])
    end
  end
end
