defmodule Program do
  @pattern ~r{\A/dev/grid/node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T}
  @max_x 36
  @max_y 27
  @goal {0, 0}

  def main do
    graph =
      "./input.txt"
      |> File.stream!
      |> Enum.reduce(%{}, &parse_line/2)

    print_graph(graph)
  end

  def print_graph(graph) do
    limit = graph[{@max_x, 0}][:size]

    Enum.each(0..@max_y, fn y ->
      Enum.each(0..@max_x, fn x ->
        tile = graph[{x,y}]

        cond do
          {x, y} == {@max_x, 0} ->
            IO.write "S"
          tile[:used] == 0 ->
            IO.write "-"
          tile[:used] <= limit ->
            IO.write "."
          true ->
            IO.write "#"
        end
      end)

      IO.puts ""
    end)
  end

  def parse_line(line, graph) do
    [x, y, size, used, available] =
      @pattern
      |> Regex.run(line, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    Map.put(graph, {x, y}, %{used: used, available: available, size: size})
  end
end

Program.main
