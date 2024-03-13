defmodule Philosopher do
  @dreaming 20
  @eating 5

  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end

  def start(hunger, right, left, name, ctrl, strength, gui) do
    spawn_link(fn -> dreaming(hunger, right, left, name, ctrl, strength, gui) end)
  end

  def dreaming(0, right, left, name, ctrl, strength, gui) do
    send(gui, {:action, name, :done})
    IO.puts("#{name} is full")
    send(ctrl, :done)
  end
  def dreaming(hunger, right, left, name, ctrl, strength, gui) do
    send(gui, {:action, name, :leave})
    IO.puts("#{name} is dreaming!")

    sleep(@dreaming)

    waiting(hunger, right, left, name, ctrl, strength, gui)
  end

  def waiting(hunger, right, left, name, ctrl, 0, gui) do
    send(gui, {:action, name, :died})
    IO.puts("#{name} is dead")
    send(ctrl, :done)
  end
  def waiting(hunger, right, left, name, ctrl, strength, gui) do
    send(gui, {:action, name, :waiting})
    IO.puts("#{name} is waiting for chopsticks! #{hunger}")

    case Chopstick.request({right, left}, 10) do
      {:ok, :ok} ->
        IO.puts("#{name} received chopsticks")
        eating(hunger, right, left, name, ctrl, strength, gui)
      _ ->
        Chopstick.return(left)
        Chopstick.return(right)
        IO.puts("#{name} timed out while waiting for chopsticks. #{strength} left")
        waiting(hunger, right, left, name, ctrl, strength - 1, gui)
    end

    #case Chopstick.request(right, 100) do
    #  :ok ->
    #    IO.puts("#{name} received right chopstick!")
    #    case Chopstick.request(left, 100) do
    #      :ok ->
    #        IO.puts("#{name} received left chopstick!")
    #        eating(hunger, right, left, name, ctrl, strength, gui)
    #      :no ->
    #        Chopstick.return(right)
    #        IO.puts("#{name} returns right chopstick!")
    #        waiting(hunger, right, left, name, ctrl, strength - 1, gui)
    #    end
    #  :no ->
    #    waiting(hunger, right, left, name, ctrl, strength - 1, gui)
    #end
  end

  def eating(hunger, right, left, name, ctrl, strength, gui) do
    send(gui, {:action, name, :enter})
    IO.puts("#{name} is eating!")

    sleep(@eating)

    Chopstick.return(right)
    Chopstick.return(left)

    dreaming(hunger - 1, right, left, name, ctrl, strength, gui)
  end
end
