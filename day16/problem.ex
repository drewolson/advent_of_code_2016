defmodule Program do
  @input "10111100110001111"
  @sample "10000"
  @size 35651584

  def main do
    @input
    |> String.graphemes
    |> build_curve
    |> checksum
    |> Enum.join
    |> IO.puts
  end

  defp build_curve(items) when length(items) >= @size do
    Enum.take(items, @size)
  end

  defp build_curve(items) do
    next_iteration =
      items
      |> Enum.reverse
      |> Enum.map(fn
        "0" -> "1"
        "1" -> "0"
      end)

    items
    |> Enum.concat(["0"|next_iteration])
    |> build_curve
  end

  defp checksum(items) when rem(length(items), 2) == 1 do
    items
  end

  defp checksum(items) do
    items
    |> Enum.chunk(2)
    |> Enum.map(fn
      [a, a] -> "1"
      _      -> "0"
    end)
    |> checksum
  end
end

Program.main
