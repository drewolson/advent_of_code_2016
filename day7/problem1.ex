defmodule Program do
  def main do
    "./input.txt"
    |> File.stream!
    |> Stream.map(&String.strip/1)
    |> Stream.map(&parse_line/1)
    |> Stream.filter(&supports_tls?/1)
    |> Enum.count
    |> IO.puts
  end

  defp contains_abba?(list) when length(list) < 4, do: false
  defp contains_abba?([a,b,b,a|_]) when a != b, do: true
  defp contains_abba?([_|rest]), do: contains_abba?(rest)

  defp parse_line(line) do
    chunks =
      line
      |> String.split(~r/\[|\]/)
      |> Enum.map(&String.split(&1, "", trim: true))

    {Enum.take_every(chunks, 2), Enum.take_every(tl(chunks), 2)}
  end

  defp supports_tls?({supernets, hypernets}) do
    Enum.any?(supernets, &contains_abba?/1) && !Enum.any?(hypernets, &contains_abba?/1)
  end
end

Program.main
