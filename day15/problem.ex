defmodule Program do
  @input [
    {1, 17, 5},
    {2, 19, 8},
    {3, 7, 1},
    {4, 13, 7},
    {5, 5, 1},
    {6, 3, 0},
    {7, 11, 0},
  ]

  def main do
    0
    |> Stream.iterate(&(&1 + 1))
    |> Stream.filter(&solved?/1)
    |> Enum.take(1)
    |> hd
    |> IO.puts
  end

  defp solved?(i) do
    Enum.all?(@input, fn {j, pos, start} ->
      rem(i + j + start, pos) == 0
    end)
  end
end

Program.main
