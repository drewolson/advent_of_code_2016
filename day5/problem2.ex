0
|> Stream.iterate(&(&1 + 1))
|> Stream.map(&to_string/1)
|> Stream.map(&("wtnhxymk" <> &1))
|> Stream.map(&(:crypto.hash(:md5, &1) |> Base.encode16(case: :lower)))
|> Stream.filter(&String.starts_with?(&1, "00000"))
|> Stream.filter(&(String.at(&1, 5) >= "0" && String.at(&1, 5) <= "7"))
|> Stream.map(&({String.at(&1, 5), String.at(&1, 6)}))
|> Enum.reduce_while(%{}, fn {key, val}, map ->
  map = Map.put_new(map, key, val)

  if Enum.count(map) == 8 do
    {:halt, map}
  else
    {:cont, map}
  end
end)
|> Enum.to_list
|> Enum.sort
|> Enum.map(&elem(&1, 1))
|> Enum.join
|> IO.puts
