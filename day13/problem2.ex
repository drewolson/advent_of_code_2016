defmodule Program do
  @input 1350

  def main do
    solve([{{1, 1}, 0}], MapSet.new([{1, 1}])) |> IO.puts
  end

  defp solve([{_, steps}|_], visited) when steps == 50 do
    Enum.count(visited)
  end

  defp solve([{position, steps}|states], visited) do
    moves =
      position
      |> available_moves
      |> Enum.filter(&valid_move?/1)
      |> Enum.reject(&MapSet.member?(visited, &1))

    visited =
      moves
      |> MapSet.new
      |> MapSet.union(visited)

    states
    |> Enum.concat(Enum.map(moves, &{&1, steps + 1}))
    |> solve(visited)
  end

  defp available_moves({x, y}) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
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
