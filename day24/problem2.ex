defmodule Program do
  def main do
    graph =
      "./input.txt"
      |> File.stream!
      |> Stream.map(&String.strip/1)
      |> build_graph

    count =
      graph
      |> Map.values
      |> Enum.filter(&is_integer/1)
      |> Enum.count

    start =
      graph
      |> Enum.find(fn {_, v} -> v == 0 end)
      |> elem(0)

    start_node = {start, MapSet.new([0])}

    [{start_node, 0}]
    |> solve(graph, MapSet.new, count, start)
    |> IO.puts
  end

  defp solve([{{pos, goals} = state, steps}|rest], graph, visited, goal_count, start) do
    cond do
      Enum.count(goals) == goal_count && pos == start ->
        steps
      Enum.member?(visited, state) ->
        solve(rest, graph, visited, goal_count, start)
      true ->
        new_states =
          pos
          |> available_moves(graph)
          |> Enum.map(&make_move(&1, goals, steps, graph))

        solve(rest ++ new_states, graph, MapSet.put(visited, state), goal_count, start)
    end
  end

  defp available_moves({x, y}, graph) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1},
    ] |> Enum.filter(&Map.has_key?(graph, &1))
  end

  defp make_move(pos, goals, steps, graph) do
    case Map.get(graph, pos) do
      i when is_integer(i) ->
        {{pos, MapSet.put(goals, i)}, steps + 1}
      _ ->
        {{pos, goals}, steps + 1}
    end
  end

  defp build_graph(lines) do
    lines
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {line, y}, map ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index
      |> Enum.reduce(map, fn {char, x}, map ->
        case char do
          "#" -> map
          "." -> Map.put(map, {x, y}, ".")
          i   -> Map.put(map, {x, y}, String.to_integer(i))
        end
      end)
    end)
  end
end

Program.main
