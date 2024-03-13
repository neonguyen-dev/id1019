defmodule Dinner do
  def start() do
    {time, _} = :timer.tc(fn -> init() end)
    time/1000
  end
  def init() do
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    ctrl = self()
    gui = Gai.start([:arendt, :hypatia, :simone, :elisabeth, :ayn])
    Philosopher.start(100, c1, c2, :arendt, ctrl, 100, gui)
    Philosopher.start(100, c2, c3, :hypatia, ctrl, 100, gui)
    Philosopher.start(100, c3, c4, :simone, ctrl, 100, gui)
    Philosopher.start(100, c4, c5, :elisabeth, ctrl, 100, gui)
    Philosopher.start(100, c5, c1, :ayn, ctrl, 100, gui)
    wait(5, [c1, c2, c3, c4, c5])
  end

  def wait(0, chopsticks) do
    Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
  end
  def wait(n, chopsticks) do
    receive do
      :done ->
        wait(n - 1, chopsticks)
      :abort ->
        Process.exit(self(), :kill)
    end
  end
end
