defmodule Program do
  @last 4294967295

  def main do
    results =
      "./input.txt"
      |> File.stream!
      |> Stream.map(&String.strip/1)
      |> Stream.map(&String.split(&1, "-"))
      |> Stream.map(&Enum.map(&1, fn token -> String.to_integer(token) end))
      |> Stream.map(&List.to_tuple/1)
      |> Enum.to_list
      |> Enum.sort
      |> process

    IO.puts hd(results)
    IO.puts Enum.count(results)
  end

  defp process(ranges, num \\ 0, results \\ [])

  defp process(_, num, results) when num > @last do
    results
  end

  defp process([], num, results) do
    Enum.concat(results, num..@last)
  end

  defp process([{first, last}|rest], num, results) when num < first do
    process(rest, last + 1, Enum.concat(results, num..(first - 1)))
  end

  defp process([{_, last}|rest], num, results) when num <= last do
    process(rest, last + 1, results)
  end

  defp process([_|rest], num, results) do
    process(rest, num, results)
  end
end

Program.main
