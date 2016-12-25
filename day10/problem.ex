defmodule Program do
  def main do
    lines =
      "./input.txt"
      |> File.stream!
      |> Stream.map(&String.strip/1)
      |> Stream.map(&String.split(&1, " "))
      |> Stream.map(&parse_line/1)

    graph =
      lines
      |> Stream.filter(&(elem(&1, 0) == "bot"))
      |> Enum.reduce(%{}, &build_graph/2)

    graph =
      lines
      |> Stream.filter(&(elem(&1, 0) == "value"))
      |> Enum.reduce(graph, &process_value/2)

    0..2
    |> Enum.flat_map(&Map.get(graph, {"output", &1}))
    |> Enum.reduce(1, &(&1 * &2))
    |> IO.puts
  end

  defp build_graph({"bot", num, low, high}, graph) do
    Map.put(graph, {"bot", num}, %{num: num, low: low, high: high, value: nil})
  end

  defp process_value({"value", value, dest}, graph) do
    move_value(graph, {"bot", dest}, value)
  end

  defp move_value(graph, dest, value) when elem(dest, 0) == "bot" do
    add_to_bot(graph, Map.get(graph, dest), value)
  end

  defp move_value(graph, dest, value) when elem(dest, 0) == "output" do
    Map.update(graph, dest, [value], &([value|&1]))
  end

  defp add_to_bot(graph, %{num: num, value: nil} = bot, value) do
    Map.put(graph, {"bot", num}, %{bot | value: value})
  end

  defp add_to_bot(graph, %{num: num, low: low, high: high, value: other} = bot, value) do
    [low_val, high_val] = Enum.sort([other, value])

    if [17, 61] == [low_val, high_val] do
      IO.puts "comparing 17 and 61 in bot #{num}"
    end

    graph
    |> Map.put({"bot", num}, %{bot | value: nil})
    |> move_value(low, low_val)
    |> move_value(high, high_val)
  end

  defp parse_line(["bot", num, "gives", "low", "to", low_type, low_dest, "and", "high", "to", high_type, high_dest]) do
    {"bot", String.to_integer(num), {low_type, String.to_integer(low_dest)}, {high_type, String.to_integer(high_dest)}}
  end

  defp parse_line(["value", num, "goes", "to", "bot", dest]) do
    {"value", String.to_integer(num), String.to_integer(dest)}
  end
end

Program.main
