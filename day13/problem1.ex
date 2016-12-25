defmodule Program do
  @goal {31, 39}
  @input 1350

  def main do
    solve([{{1, 1}, 0}], MapSet.new) |> IO.puts
  end

  defp solve([{position, steps}|_], _) when position == @goal, do: steps

  defp solve([{position, steps}|states], visited) do
    if MapSet.member?(visited, position) do
      solve(states, visited)
    else
      position
      |> available_moves
      |> Enum.filter(&valid_move?/1)
      |> Enum.map(&{&1, steps + 1})
      |> Enum.concat(states)
      |> Enum.sort_by(&heuristic/1)
      |> solve(MapSet.put(visited, position))
    end
  end

  defp available_moves({x, y}) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
  end

  defp heuristic({{x, y}, steps}) do
    {x1, y1} = @goal

    abs(x1 - x) + abs(y1 - y) + steps
  end

  defp valid_move?({x, y}) when x < 0 or y < 0, do: false

  defp valid_move?({x, y}) do
    code = x*x + 3*x + 2*x*y + y + y*y + @input

    valid_code?(code)
  end

  defp valid_code?(code, count \\ 0)

  defp valid_code?(code, count) when code == 0 do
    rem(count, 2) == 0
  end

  defp valid_code?(code, count) do
    use Bitwise

    valid_code?(code &&& (code - 1), count + 1)
  end
end

Program.main
