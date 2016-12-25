defmodule Program do
  @input "pslxynzg"
  @pattern Regex.compile!("[bcdef]")

  def main do
    solve([{{0, 0}, []}], [])
    |> Enum.map(&Enum.count/1)
    |> Enum.max
    |> IO.puts
  end

  defp solve([], paths) do
    paths
  end

  defp solve([{loc, path}|rest], paths) when loc == {3, 3} do
    solve(rest, [path|paths])
  end

  defp solve([{loc, path}|states], paths) do
    valid_dirs = valid_dirs(path)

    moves =
      loc
      |> available_moves
      |> Enum.filter(&valid_move?(&1, valid_dirs))

    states
    |> Enum.concat(Enum.map(moves, fn {loc, dir} -> {loc, path ++ [dir]} end))
    |> solve(paths)
  end

  defp available_moves({x, y}) do
    [
      {{x + 1, y}, "R"},
      {{x - 1, y}, "L"},
      {{x, y + 1}, "D"},
      {{x, y - 1}, "U"}
    ]
  end

  defp valid_dirs(path) do
    :md5
    |> :crypto.hash(@input <> Enum.join(path))
    |> Base.encode16(case: :lower)
    |> String.graphemes
    |> Enum.take(4)
    |> Enum.zip(["U", "D", "L", "R"])
    |> Enum.filter(fn {e, _} -> e =~ @pattern end)
    |> Enum.map(&elem(&1, 1))
  end

  defp valid_move?({{x, y}, _}, _) when x < 0 or y < 0 or x > 3 or y > 3, do: false
  defp valid_move?({_, dir}, valid_dirs) do
    Enum.member?(valid_dirs, dir)
  end
end

Program.main
