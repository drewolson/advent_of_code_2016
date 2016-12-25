defmodule Program do
  def main do
    "./input.txt"
    |> File.stream!
    |> Stream.map(&String.strip/1)
    |> Stream.map(&parse_line/1)
    |> Enum.to_list
    |> Stream.filter(&valid?/1)
    |> Stream.map(&decrypt/1)
    |> Enum.to_list
    |> Enum.find(fn {name, _} -> Regex.match?(~r/pole/i, name) end)
    |> IO.inspect
  end

  defp decrypt({_, _, sector_id, encrypted_name}) do
    decrypted =
      encrypted_name
      |> String.split("-")
      |> Enum.map(&decrypt_word(&1, sector_id))
      |> Enum.join(" ")

    {decrypted, sector_id}
  end

  defp decrypt_word(encrypted_name, sector_id) do
    encrypted_name
    |> to_charlist
    |> Enum.map(&(&1 - 97))
    |> Enum.map(&(&1 + sector_id))
    |> Enum.map(&rem(&1, 26))
    |> Enum.map(&(&1 + 97))
    |> to_string
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

    {name, checksum, String.to_integer(sector_id), encrypted_name}
  end

  defp valid?({items, checksum, _, _}) do
    expected =
      items
      |> grouped
      |> Enum.sort_by(&(-elem(&1, 0)))
      |> Enum.take(5)
      |> Enum.map(&elem(&1, 1))
      |> Enum.join

    expected == checksum
  end
end

Program.main
