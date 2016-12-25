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
    |> execute(0, %{"a" => 12, "b" => 0, "c" => 0, "d" => 0})
    |> Map.get("a")
    |> IO.puts
  end

  defp execute(instructions, line_num, env) do
    if line_num >= Enum.count(instructions) do
      env
    else
      case Enum.map(line_num..line_num+5, &Map.get(instructions, &1)) do
        [["cpy", b, c], ["inc", a], ["dec", c], ["jnz", c, -2], ["dec", d], ["jnz", d, -5]] ->
          val_a = expand(a, env)
          val_b = expand(b, env)
          val_d = expand(d, env)

          env =
            env
            |> Map.put(a, val_a + val_b * val_d)
            |> Map.put(c, 0)
            |> Map.put(d, 0)

          execute(instructions, line_num + 6, env)
        _ ->
          {instructions, line_num, env} = execute_line(instructions, instructions[line_num], line_num, env)

          execute(instructions, line_num, env)
      end
    end
  end

  defp execute_line(instructions, ["cpy", from, to], line_num, env) when is_binary(to) do
    env = Map.put(env, to, expand(from, env))

    {instructions, line_num + 1, env}
  end

  defp execute_line(instructions, ["inc", register], line_num, env) do
    env = Map.put(env, register, expand(register, env) + 1)

    {instructions, line_num + 1, env}
  end

  defp execute_line(instructions, ["dec", register], line_num, env) do
    env = Map.put(env, register, expand(register, env) - 1)

    {instructions, line_num + 1, env}
  end

  defp execute_line(instructions, ["jnz", pred, to], line_num, env) do
    pred = expand(pred, env)

    if pred == 0 do
      {instructions, line_num + 1, env}
    else
      {instructions, line_num + expand(to, env), env}
    end
  end

  defp execute_line(instructions, ["tgl", to], line_num, env) do
    target = line_num + expand(to, env)

    if Map.has_key?(instructions, target) do
      instructions = Map.update!(instructions, target, fn
        ["inc", x]    -> ["dec", x]
        [_, x]        -> ["inc", x]
        ["jnz", x, y] -> ["cpy", x, y]
        [_, x, y]     -> ["jnz", x, y]
      end)

      {instructions, line_num + 1, env}
    else
      {instructions, line_num + 1, env}
    end
  end

  defp execute_line(instructions, _, line_num, env) do
    {instructions, line_num + 1, env}
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
