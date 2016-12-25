defmodule Program do
  def main do
    "./input.txt"
    |> File.stream!
    |> Stream.map(&String.strip/1)
    |> Stream.map(&String.split/1)
    |> Stream.map(&to_ints/1)
    |> Stream.filter(&valid_triangle?/1)
    |> Enum.count
    |> IO.puts
  end

  defp to_ints(items) do
    Enum.map(items, &String.to_integer/1)
  end

  defp valid_triangle?([a, b, c]) do
    a + b > c && a + c > b && b + c > a
  end
end

Program.main
