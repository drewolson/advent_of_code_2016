defmodule Program do
  def main do
    "./input1.txt"
    |> File.stream!
    |> Stream.map(&String.strip/1)
    |> Stream.flat_map(&String.split(&1, ", "))
    |> Stream.map(&parse_token/1)
    |> Enum.reduce({:north, {0, 0}}, &process_token/2)
    |> distance
    |> IO.puts
  end

  defp distance({_, {x, y}}), do: abs(x) + abs(y)

  defp move({:north, {x, y}}, blocks), do: {:north, {x, y + blocks}}
  defp move({:south, {x, y}}, blocks), do: {:south, {x, y - blocks}}
  defp move({:east, {x, y}}, blocks),  do: {:east, {x + blocks, y}}
  defp move({:west, {x, y}}, blocks),  do: {:west, {x - blocks, y}}

  defp parse_token(token) do
    [dir|rest] = String.graphemes(token)
    blocks = rest |> Enum.join |> String.to_integer

    {dir, blocks}
  end

  defp process_token({dir, blocks}, state) do
    state
    |> turn(dir)
    |> move(blocks)
  end

  defp turn({:north, coords}, "L"), do: {:west, coords}
  defp turn({:north, coords}, "R"), do: {:east, coords}

  defp turn({:east, coords}, "L"),  do: {:north, coords}
  defp turn({:east, coords}, "R"),  do: {:south, coords}

  defp turn({:south, coords}, "L"), do: {:east, coords}
  defp turn({:south, coords}, "R"), do: {:west, coords}

  defp turn({:west, coords}, "L"),  do: {:south, coords}
  defp turn({:west, coords}, "R"),  do: {:north, coords}
end

Program.main
