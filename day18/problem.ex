defmodule Program do
  @input ".^^^^^.^^.^^^.^...^..^^.^.^..^^^^^^^^^^..^...^^.^..^^^^..^^^^...^.^.^^^^^^^^....^..^^^^^^.^^^.^^^.^^"

  def main do
    Agent.start_link(fn -> 0 end, name: :counter)

    row =
      @input
      |> String.graphemes
      |> Enum.with_index
      |> Enum.map(fn
        {".", x} ->
          Agent.update(:counter, &(&1 + 1))
          {{x, 0}, :safe}
        {"^", x} -> {{x, 0}, :trap}
      end)
      |> Enum.into(%{})

    Enum.reduce(1..399999, row, &build_rows/2)

    Agent.get(:counter, &IO.puts/1)
  end

  defp build_rows(y, last_row) do
    Enum.reduce(0..(String.length(@input) - 1), %{}, &add_tile({&1, y}, last_row, &2))
  end

  defp add_tile({x, y} = key, last_row, row) do
    tiles =
      [{x-1,y-1},{x,y-1},{x+1,y-1}]
      |> Enum.map(&Map.get(last_row, &1, :safe))

    val = case tiles do
      [:trap, :trap, :safe] -> :trap
      [:safe, :trap, :trap] -> :trap
      [:trap, :safe, :safe] -> :trap
      [:safe, :safe, :trap] -> :trap
      _ ->
        Agent.update(:counter, &(&1 + 1))
        :safe
    end

    Map.put(row, key, val)
  end
end

Program.main
