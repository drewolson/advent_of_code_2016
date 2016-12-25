defmodule Program do
  def main do
    "./input.txt"
    |> File.stream!
    |> Stream.map(&String.strip/1)
    |> Stream.map(&String.split(&1, " "))
    |> Stream.map(&parse_ints/1)
    |> Enum.with_index
    |> Enum.map(fn {line, i} -> {i, line} end)
    |> Enum.into(%{})
    |> execute(0, %{"a" => 0, "b" => 0, "c" => 1, "d" => 0})
    |> Map.get("a")
    |> IO.puts
  end

  defp execute(instructions, line_num, env) do
    if line_num >= Enum.count(instructions) do
      env
    else
      {line_num, env} = execute_line(instructions[line_num], line_num, env)

      execute(instructions, line_num, env)
    end
  end

  defp execute_line(["cpy", from, to], line_num, env) do
    env = Map.put(env, to, expand(from, env))

    {line_num + 1, env}
  end

  defp execute_line(["inc", register], line_num, env) do
    env = Map.put(env, register, expand(register, env) + 1)

    {line_num + 1, env}
  end

  defp execute_line(["dec", register], line_num, env) do
    env = Map.put(env, register, expand(register, env) - 1)

    {line_num + 1, env}
  end

  defp execute_line(["jnz", pred, to], line_num, env) do
    pred = expand(pred, env)

    if pred == 0 do
      {line_num + 1, env}
    else
      {line_num + expand(to, env), env}
    end
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
