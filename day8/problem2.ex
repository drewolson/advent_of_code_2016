defmodule Program do
  @height 5
  @width 49

  def main do
    "./input.txt"
    |> File.stream!
    |> Stream.map(&String.strip/1)
    |> Stream.map(&String.split(&1, " "))
    |> Stream.map(&parse_line/1)
    |> Enum.reduce(empty_keypad, &process_line/2)
    |> display
  end

  defp display(keypad) do
    Enum.each(0..@height, fn y ->
      0..@width
      |> Enum.map(&Map.get(keypad, {&1, y}))
      |> Enum.map(fn
        :off -> " "
        :on -> "#"
      end)
      |> Enum.join
      |> IO.puts
    end)
  end

  defp empty_keypad do
    Enum.reduce(0..@width, %{}, fn x, map ->
      Enum.reduce(0..@height, map, &Map.put(&2, {x, &1}, :off))
    end)
  end

  defp parse_line(["rect", data]) do
    [x, y] =
      data
      |> String.split("x")
      |> Enum.map(&String.to_integer/1)

    {:rect, x, y}
  end

  defp parse_line(["rotate", _, data, "by", num]) do
    [dir, index] =
      data
      |> String.split("=")

    {:rotate, dir, String.to_integer(index), String.to_integer(num)}
  end

  defp process_line({:rect, x, y}, keypad) do
    Enum.reduce(0..(x-1), keypad, fn x, map ->
      Enum.reduce(0..(y-1), map, &Map.put(&2, {x, &1}, :on))
    end)
  end

  defp process_line({:rotate, dir, index, num}, keypad) do
    line = get_line(keypad, dir, index)

    keypad = Enum.reduce(line, keypad, fn {{x, y}, _val}, keypad ->
      Map.put(keypad, {x, y}, :off)
    end)

    Enum.reduce(line, keypad, fn {{x, y}, val}, keypad ->
      shift_cell(keypad, dir, x, y, num, val)
    end)
  end

  defp get_line(keypad, "x", index) do
    Enum.map(0..@height, fn y ->
      {{index, y}, Map.get(keypad, {index, y})}
    end)
  end

  defp get_line(keypad, "y", index) do
    Enum.map(0..@width, fn x ->
      {{x, index}, Map.get(keypad, {x, index})}
    end)
  end

  defp shift_cell(keypad, "x", x, y, num, val) do
    Map.put(keypad, {x, rem(y + num, @height + 1)}, val)
  end

  defp shift_cell(keypad, "y", x, y, num, val) do
    Map.put(keypad, {rem(x + num, @width + 1), y}, val)
  end
end

Program.main
