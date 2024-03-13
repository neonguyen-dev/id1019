defmodule Chopstick do
  def start do
    stick = spawn_link(fn -> available() end)
  end

  def available() do
    receive do
      {:request, from} ->
        send(from, :granted)
        gone()
      :quit ->
        :ok
    end
  end

  def gone() do
    receive do
      :return -> available()
      :quit -> :ok
    end
  end

  def request(stick) do
    send(stick, {:request, self()})

    receive do
      :granted -> :ok
    end
  end

  #def request(stick, timeout) do
  #  send(stick, {:request, self()})
  #  receive do
  #  :granted ->
  #    :ok
  #  after timeout ->
  #    :no
  #  end
  #end

  def request({right, left}, timeout) do
    send(right, {:request, self()})
    send(left, {:request, self()})

    {granted(timeout), granted(timeout)}
  end

  def granted(timeout) do
    receive do
      :granted -> :ok
      _ -> granted(timeout)
    after
      timeout -> :no
    end
  end

  def return(stick) do
    send(stick, :return)
  end

  def quit(stick) do
    send(stick, :quit)
  end
end
