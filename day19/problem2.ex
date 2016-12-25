defmodule Program do
  @input 3012210

  def main do
    1..@input
    |> Enum.to_list
    |> solve(@input)
    |> IO.puts
  end

  defp solve([_,_,a], _), do: a

  defp solve(list, count) do
    removal_count = div(count, 4)
    {start, rest} = Enum.split(list, div(count, 2))
    {new_end, new_start} = Enum.split(start, removal_count)

    sparse_rest = if rem(count, 2) == 0 do
      remove(rest, removal_count, [])
    else
      [_,a|rest] = rest
      remove(rest, removal_count - 1, [a])
    end

    solve(new_start ++ sparse_rest ++ new_end, count - removal_count)
  end

  defp remove(list, 0, result) do
    result
    |> Enum.reverse
    |> Enum.concat(list)
  end

  defp remove([_|rest], 1, result) do
    remove(rest, 0, result)
  end

  defp remove([_,_,a|rest], count, result) do
    remove(rest, count - 2, [a|result])
  end
end

Program.main
