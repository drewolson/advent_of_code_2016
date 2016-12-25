defmodule Program do
  @sample %{
    1 => [{1, :m}, {2, :m}],
    2 => [{1, :g}],
    3 => [{2, :g}],
    4 => []
  }

  @input %{
    1 => [{1, :g}, {1, :m}, {6, :g}, {6, :m}, {7, :g}, {7, :m}],
    2 => [{2, :g}, {3, :g}, {4, :g}, {5, :g}],
    3 => [{2, :m}, {3, :m}, {4, :m}, {5, :m}],
    4 => []
  }

  def main do
    {:ok, visited} = Agent.start_link(&MapSet.new/0)

    [{@input, 1}]
    |> solve(0, visited)
    |> IO.puts
  end

  defp solve(states, steps, visited) do
    results = Enum.flat_map(states, fn {state, elevator} ->
      state
      |> available_moves(elevator)
      |> Enum.map(&make_move(state, &1))
      |> Enum.filter(fn {state, _} -> valid?(state) end)
      |> Enum.reject(fn result -> Agent.get(visited, &MapSet.member?(&1, result)) end)
      |> Enum.map(fn result -> Agent.get_and_update(visited, &{result, MapSet.put(&1, result)}) end)
    end)

    if Enum.any?(results, &solved?/1) do
      steps + 1
    else
      solve(results, steps + 1, visited)
    end
  end

  defp solved?({%{4 => row}, 4}) when length(row) == 14, do: true
  defp solved?(_), do: false

  def available_moves(state, elevator) do
    row = state[elevator]

    pairs =
      row
      |> Enum.flat_map(fn item ->
        row
        |> Enum.drop_while(&(&1 != item))
        |> Enum.drop(1)
        |> Enum.map(&([item, &1]))
      end)
      |> Enum.reject(&match?([{i, :g}, {j, :m}] when i != j, &1))
      |> Enum.sort

    solos =
      state[elevator]
      |> Enum.map(&([&1]))
      |> Enum.sort

    (solos ++ pairs)
    |> Enum.flat_map(&[{&1, elevator, elevator + 1}, {&1, elevator, elevator - 1}])
    |> Enum.reject(&match?({_, _, level} when level > 4 or level < 1, &1))
  end

  def make_move(state, {items, from, to}) do
    state =
      state
      |> Map.update!(from, fn row -> Enum.reduce(items, row, &List.delete(&2, &1)) end)
      |> Map.update!(to, &(items ++ &1 |> Enum.sort))

    {state, to}
  end

  def valid?(state) do
    state
    |> Map.values
    |> Enum.all?(fn row ->
      ms = row |> Enum.filter(&match?({_, :m}, &1))
      gs = row |> Enum.filter(&match?({_, :g}, &1))

      if gs == [] do
        true
      else
        unmatched_ms = ms |> Enum.reject(fn {i, :m} -> Enum.member?(row, {i, :g}) end)

        if unmatched_ms == [] do
          true
        else
          false
        end
      end
    end)
  end
end

Program.main
