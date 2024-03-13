defmodule Color do
  def convert(depth, max) do
    test(depth, max)
  end

  def red(depth, max) do
    f = depth/max

    a = f * 4
    x = trunc(a)
    y = trunc(255*(a - x))

    case x do
      # black -> red
      0 -> {:rgb, y, 0, 0}
      # red -> yellow
      1 -> {:rgb, 255, y, 0}
      # yellow -> green
      2 -> {:rgb, 255 - y, 255, 0}
      # green -> cyan
      3 -> {:rgb, 0, 255, y}
      # cyan -> blue
      4 -> {:rgb, 0, 255 - y, 255}
    end
  end

  def test(depth, max) do
    f = depth/max

    a = f * 4
    x = trunc(a)
    y = trunc(255*(a - x))

    case x do
      # black -> purple
      0 -> {:rgb, y, 0, y}
      # purple -> blue
      1 -> {:rgb, y, 0, 255}
      # blue -> cyan
      2 -> {:rgb, 0, y, 255}
      # cyan -> green
      3 -> {:rgb, 0, 255, y}
      # green -> yellow
      4 -> {:rgb, y, 255, 0}
    end
  end
end
