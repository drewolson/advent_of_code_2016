defmodule Program do
  @check_length 10

  def main do
    goal =
      [0, 1]
      |> Stream.cycle
      |> Enum.take(@check_length)

    instructions =
      "./input.txt"
      |> File.stream!
      |> Stream.map(&String.strip/1)
      |> Stream.map(&String.split(&1, " "))
      |> Stream.map(&parse_ints/1)
      |> Enum.with_index
      |> Enum.map(fn {line, i} -> {i, line} end)
      |> Enum.into(%{})

    0
    |> Stream.iterate(&(&1 + 1))
    |> Enum.find(fn i ->
      output = execute(instructions, 0, %{"a" => i, "b" => 0, "c" => 0, "d" => 0}, [])
      output == goal
    end)
    |> IO.puts
  end

  defp execute(_, _, _, output) when length(output) == @check_length do
    Enum.reverse(output)
  end

  defp execute(instructions, line_num, env, output) do
    if line_num >= Enum.count(instructions) do
      env
    else
      {line_num, env, output} = execute_line(instructions[line_num], line_num, env, output)

      execute(instructions, line_num, env, output)
    end
  end

  defp execute_line(["cpy", from, to], line_num, env, output) do
    env = Map.put(env, to, expand(from, env))

    {line_num + 1, env, output}
  end

  defp execute_line(["inc", register], line_num, env, output) do
    env = Map.put(env, register, expand(register, env) + 1)

    {line_num + 1, env, output}
  end

  defp execute_line(["dec", register], line_num, env, output) do
    env = Map.put(env, register, expand(register, env) - 1)

    {line_num + 1, env, output}
  end

  defp execute_line(["jnz", pred, to], line_num, env, output) do
    pred = expand(pred, env)

    if pred == 0 do
      {line_num + 1, env, output}
    else
      {line_num + expand(to, env), env, output}
    end
  end

  defp execute_line(["out", register], line_num, env, output) do
    new = expand(register, env)

    {line_num + 1, env, [new|output]}
  end

  defp expand(token, _env) when is_integer(token), do: token
  defp expand(token, env), do: expand(env[token], env)

  defp parse_ints(tokens) do
    Enum.map(tokens, fn token ->
      case Integer.parse(token) do
        {i, _} -> i
        :error -> token
      end
    end)
  end
end

Program.main
