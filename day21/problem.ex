defmodule Program do
  @plaintext "abcdefgh"
  @ciphertext "fbgdceah"

  def main do
    plaintext = String.graphemes(@plaintext)
    ciphertext = String.graphemes(@ciphertext)

    instructions =
      "./input.txt"
      |> File.stream!
      |> Stream.map(&String.strip/1)
      |> Stream.map(&String.replace(&1, "steps", "step"))
      |> Stream.map(&String.split(&1, " "))
      |> Stream.map(&parse_line/1)
      |> Enum.to_list

    plaintext
    |> encrypt(instructions)
    |> IO.puts

    ciphertext
    |> crack(instructions)
    |> IO.puts
  end

  def crack(scrambled, instructions) do
    scrambled
    |> permutations
    |> Enum.find(fn permutation ->
      encrypt(permutation, instructions) == scrambled
    end)
  end

  def permutations(chars) when length(chars) == 1 do
    [chars]
  end

  def permutations(chars) do
    Stream.flat_map(chars, fn char ->
      chars
      |> List.delete(char)
      |> permutations
      |> Stream.map(&[char|&1])
    end)
  end

  def encrypt(password, instructions) do
    Enum.reduce(instructions, password, &scramble/2)
  end

  def scramble({"swap_pos", a, b}, chars) do
    new_a = Enum.at(chars, b)
    new_b = Enum.at(chars, a)

    chars
    |> List.replace_at(a, new_a)
    |> List.replace_at(b, new_b)
  end

  def scramble({"swap_letter", a, b}, chars) do
    Enum.map(chars, fn
      ^a -> b
      ^b -> a
      c -> c
    end)
  end

  def scramble({"rotate", "left", a}, chars) do
    rotate(chars, a)
  end

  def scramble({"rotate", "right", a}, chars) do
    {"rotate", "left", a}
    |> scramble(Enum.reverse(chars))
    |> Enum.reverse
  end

  def scramble({"rotate_letter", a}, chars) do
    index = case Enum.find_index(chars, &(&1 == a)) do
      i when i > 3 -> i + 2
      i -> i + 1
    end

    scramble({"rotate", "right", index}, chars)
  end

  def scramble({"reverse", a, b}, chars) do
    {start, rest} = Enum.split(chars, a)
    {middle, rest} = Enum.split(rest, b - a + 1)

    start ++ Enum.reverse(middle) ++ rest
  end

  def scramble({"move", a, b}, chars) do
    c = Enum.at(chars, a)

    chars
    |> List.delete_at(a)
    |> List.insert_at(b, c)
  end

  def rotate(chars, 0), do: chars
  def rotate([h|t], n), do: rotate(t ++ [h], n - 1)

  def parse_line(["swap", "position", a, "with", "position", b]) do
    {"swap_pos", String.to_integer(a), String.to_integer(b)}
  end

  def parse_line(["swap", "letter", a, "with", "letter", b]) do
    {"swap_letter", a, b}
  end

  def parse_line(["rotate", dir, x, "step"]) do
    {"rotate", dir, String.to_integer(x)}
  end

  def parse_line(["rotate", "based", "on", "position", "of", "letter", a]) do
    {"rotate_letter", a}
  end

  def parse_line(["reverse", "positions", a, "through", b]) do
    {"reverse", String.to_integer(a), String.to_integer(b)}
  end

  def parse_line(["move", "position", a, "to", "position", b]) do
    {"move", String.to_integer(a), String.to_integer(b)}
  end
end

Program.main
