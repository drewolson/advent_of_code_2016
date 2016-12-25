defmodule Program do
  @pattern ~r{\A/dev/grid/node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T}

  def main do
    "./input.txt"
    |> File.stream!
    |> Enum.map(&parse_line/1)
    |> find_pairs
    |> Enum.count
    |> IO.puts
  end

  def find_pairs(candidates) do
    candidates
    |> Enum.filter(&(&1.used > 0))
    |> Enum.flat_map(fn candidate ->
      candidates
      |> List.delete(candidate)
      |> Enum.filter(&(&1.available >= candidate.used))
      |> Enum.map(&{candidates, &1})
    end)
  end

  def parse_line(line) do
    [x, y, size, used, available] =
      @pattern
      |> Regex.run(line, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    %{pos: {x, y}, size: size, used: used, available: available}
  end
end

Program.main
