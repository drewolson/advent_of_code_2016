defmodule Program do
  def main do
    "./input.txt"
    |> File.stream!
    |> Stream.map(&String.strip/1)
    |> Stream.map(&parse_line/1)
    |> Enum.to_list
    |> Stream.filter_map(&valid?/1, &elem(&1, 2))
    |> Enum.sum
    |> IO.puts
  end

  defp grouped([item|rest]) do
    grouped(rest, [{1, item}])
  end

  defp grouped([], counts) do
    Enum.reverse(counts)
  end

  defp grouped([item|items], [{count, other}|rest]) when item == other do
    grouped(items, [{count + 1, other}|rest])
  end

  defp grouped([item|rest], counts) do
    grouped(rest, [{1, item}|counts])
  end

  defp parse_line(line) do
    [_,encrypted_name,sector_id,checksum] = Regex.run(~r/\A([a-z\-]+)-(\d+)\[([a-z]+)\]\z/, line)

    name =
      encrypted_name
      |> String.split("", trim: true)
      |> Enum.reject(&(&1 == "-"))
      |> Enum.sort

    {name, checksum, String.to_integer(sector_id)}
  end

  defp valid?({name, checksum, _}) do
    expected =
      name
      |> grouped
      |> Enum.sort_by(&(-elem(&1, 0)))
      |> Enum.take(5)
      |> Enum.map(&elem(&1, 1))
      |> Enum.join

    expected == checksum
  end
end

Program.main
