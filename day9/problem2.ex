defmodule Program do
  def main do
    "./input.txt"
    |> File.read!
    |> String.strip
    |> decompress
    |> IO.puts
  end

  defp decompress(raw, count \\ 0)

  defp decompress("", count), do: count

  defp decompress(<<"(", rest::binary>>, count) do
    [counts, rest] = String.split(rest, ")", parts: 2)
    [num, times] = counts |> String.split("x") |> Enum.map(&String.to_integer/1)
    {compressed, rest} = String.split_at(rest, num)

    decompress(String.duplicate(compressed, times) <> rest, count)
  end

  defp decompress(<<_::binary-size(1), rest::binary>>, count) do
    decompress(rest, count + 1)
  end
end

Program.main
