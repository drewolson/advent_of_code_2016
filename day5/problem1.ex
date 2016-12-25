0
|> Stream.iterate(&(&1 + 1))
|> Stream.map(&to_string/1)
|> Stream.map(&("wtnhxymk" <> &1))
|> Stream.map(&(:crypto.hash(:md5, &1) |> Base.encode16(case: :lower)))
|> Stream.filter(&String.starts_with?(&1, "00000"))
|> Stream.map(&String.at(&1, 5))
|> Enum.take(8)
|> Enum.join
|> IO.puts
