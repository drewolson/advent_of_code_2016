defmodule Program do
  @input 3012210

  def main do
    1..@input
    |> Enum.to_list
    |> solve(@input)
    |> IO.puts
  end

  defp solve([a], _), do: a

  defp solve(list, count) do
    if rem(count, 2) == 0  do
      list
      |> Enum.take_every(2)
      |> solve(div(count, 2))
    else
      list
      |> Enum.take_every(2)
      |> Enum.drop(1)
      |> solve(div(count, 2))
    end
  end
end

Program.main
