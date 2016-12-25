defmodule Program do
  def main do
    "./input.txt"
    |> File.stream!
    |> Stream.map(&String.strip/1)
    |> Stream.map(&parse_line/1)
    |> Stream.filter(&supports_ssl?/1)
    |> Enum.count
    |> IO.puts
  end

  defp find_abas(items) do
    items
    |> Enum.chunk(3, 1)
    |> Enum.filter(&match?([a,b,a] when a != b, &1))
  end

  defp include_babs?(items, babs) do
    items
    |> Enum.chunk(3, 1)
    |> Enum.any?(&Enum.member?(babs, &1))
  end

  defp parse_line(line) do
    chunks =
      line
      |> String.split(~r/\[|\]/)
      |> Enum.map(&String.split(&1, "", trim: true))

    {Enum.take_every(chunks, 2), Enum.take_every(tl(chunks), 2)}
  end

  defp supports_ssl?({supernets, hypernets}) do
    babs =
      supernets
      |> Enum.flat_map(&find_abas/1)
      |> Enum.map(&to_bab/1)

    Enum.any?(hypernets, &include_babs?(&1, babs))
  end

  defp to_bab([a, b, a]), do: [b, a, b]
end

Program.main
