defmodule Program do
  def main do
    "./input1.txt"
    |> File.stream!
    |> Stream.map(&String.strip/1)
    |> Stream.flat_map(&String.split(&1, ", "))
    |> Stream.map(&parse_token/1)
    |> Enum.reduce(%{dir: :north, coords: {0, 0}, visits: [], hq: nil}, &process_token/2)
    |> distance
    |> IO.puts
  end

  defp distance(%{hq: {x, y}}), do: abs(x) + abs(y)

  defp move(state, 0), do: state

  defp move(%{dir: dir, coords: {x, y}} = state, blocks) do
    state = case dir do
      :north -> %{state | coords: {x, y + 1}}
      :south -> %{state | coords: {x, y - 1}}
      :east  -> %{state | coords: {x + 1, y}}
      :west  -> %{state | coords: {x - 1, y}}
    end

    state
    |> record
    |> move(blocks - 1)
  end

  defp parse_token(token) do
    [dir|rest] = String.graphemes(token)
    blocks = rest |> Enum.join |> String.to_integer

    {dir, blocks}
  end

  defp process_token({dir, blocks}, state) do
    state
    |> turn(dir)
    |> move(blocks)
  end

  defp record(%{coords: coords, visits: visits, hq: nil} = state) do
    if Enum.member?(visits, coords) do
      %{state | hq: coords}
    else
      %{state | visits: [coords|visits]}
    end
  end

  defp record(state), do: state

  defp turn(%{dir: :north} = state, "L"), do: %{state | dir: :west}
  defp turn(%{dir: :north} = state, "R"), do: %{state | dir: :east}

  defp turn(%{dir: :east} = state, "L"), do: %{state | dir: :north}
  defp turn(%{dir: :east} = state, "R"), do: %{state | dir: :south}

  defp turn(%{dir: :south} = state, "L"), do: %{state | dir: :east}
  defp turn(%{dir: :south} = state, "R"), do: %{state | dir: :west}

  defp turn(%{dir: :west} = state, "L"), do: %{state | dir: :south}
  defp turn(%{dir: :west} = state, "R"), do: %{state | dir: :north}
end

Program.main
