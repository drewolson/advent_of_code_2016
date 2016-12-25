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
      {0, 0} -> "7"
      {0, 1} -> "4"
      {0, 2} -> "1"
      {1, 0} -> "8"
      {1, 1} -> "5"
      {1, 2} -> "2"
      {2, 0} -> "9"
      {2, 1} -> "6"
      {2, 2} -> "3"
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

  defp process_token("U", {_, 2} = coords), do: coords
  defp process_token("U", {x, y}), do: {x, y + 1}

  defp process_token("D", {_, 0} = coords), do: coords
  defp process_token("D", {x, y}), do: {x, y - 1}

  defp process_token("L", {0, _} = coords), do: coords
  defp process_token("L", {x, y}), do: {x - 1, y}

  defp process_token("R", {2, _} = coords), do: coords
  defp process_token("R", {x, y}), do: {x + 1, y}

  def result({_, digits}) do
    digits
    |> Enum.reverse
    |> Enum.join
  end
end

Program.main
