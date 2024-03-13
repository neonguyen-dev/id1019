defmodule Test do
  def demo() do
    small(-1.2, 0.2, 0.5)
  end

  def small(x0, y0, xn) do
    width = 3840
    height = 2160
    depth = 512
    k = 0.00002
    image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
    PPM.write("small1.ppm", image)
  end
end
