"./input.txt"
|> File.stream!
|> Enum.map(&String.strip/1)
|> Enum.map(&String.split(&1, "", trim: true))
|> List.zip
|> Enum.map(&Tuple.to_list/1)
|> Enum.map(fn chars ->
  Enum.reduce(chars, %{}, fn char, counts ->
    Map.update(counts, char, 1, &(&1 + 1))
  end)
end)
|> Enum.map(&Enum.max_by(&1, fn t -> elem(t, 1) end))
|> Enum.map(&elem(&1, 0))
|> Enum.join
|> IO.puts
