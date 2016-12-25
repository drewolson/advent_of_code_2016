defmodule Program do
  def main do
    "./input.txt"
    |> File.stream!
    |> Stream.map(&String.strip/1)
    |> Stream.map(&String.split(&1, "", trim: true))
    |> Enum.reduce({{1,1}, []}, &process_line/2)
    |> result
    |> IO.puts
  end

  defp digit(coords) do
    case coords do
      {0, 2} -> "5"
      {1, 1} -> "A"
      {1, 2} -> "6"
      {1, 3} -> "2"
      {2, 0} -> "D"
      {2, 1} -> "B"
      {2, 2} -> "7"
      {2, 3} -> "3"
      {2, 4} -> "1"
      {3, 1} -> "C"
      {3, 2} -> "8"
      {3, 3} -> "4"
      {4, 2} -> "9"
    end
  end

  defp move([], coords), do: coords

  defp move([dir|rest], coords) do
    move(rest, process_token(dir, coords))
  end

  defp process_line(line, {coords, digits}) do
    new_coords = move(line, coords)
    code = [digit(new_coords)|digits]

    {new_coords, code}
  end

  defp process_token("U", coords) when coords in [{0, 2}, {1, 3}, {2, 4}, {3, 3}, {4, 2}], do: coords
  defp process_token("U", {x, y}), do: {x, y + 1}

  defp process_token("D", coords) when coords in [{0, 2}, {1, 1}, {2, 0}, {3, 1}, {4, 2}], do: coords
  defp process_token("D", {x, y}), do: {x, y - 1}

  defp process_token("L", coords) when coords in [{2, 0}, {1, 1}, {0, 2}, {1, 3}, {2, 4}], do: coords
  defp process_token("L", {x, y}), do: {x - 1, y}

  defp process_token("R", coords) when coords in [{2, 0}, {3, 1}, {4, 2}, {3, 3}, {2, 4}], do: coords
  defp process_token("R", {x, y}), do: {x + 1, y}

  def result({_, digits}) do
    digits
    |> Enum.reverse
    |> Enum.join
  end
end

Program.main
