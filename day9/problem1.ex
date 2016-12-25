defmodule Program do
  def main do
    "./input.txt"
    |> File.read!
    |> String.strip
    |> decompress
    |> String.length
    |> IO.puts
  end

  defp decompress(raw, processed \\ "")

  defp decompress("", processed), do: processed

  defp decompress(<<"(", rest::binary>>, processed) do
    [counts, rest] = String.split(rest, ")", parts: 2)
    [num, times] = counts |> String.split("x") |> Enum.map(&String.to_integer/1)
    {compressed, rest} = String.split_at(rest, num)

    decompress(rest, processed <> String.duplicate(compressed, times))
  end

  defp decompress(<<c::binary-size(1), rest::binary>>, processed) do
    decompress(rest, processed <> c)
  end
end

Program.main
