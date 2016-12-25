defmodule Program do
  @sample "abc"
  @input "zpqevtbw"

  def main do
    0
    |> Stream.iterate(&(&1 + 1))
    |> Stream.map(&{&1, hash(&1)})
    |> Enum.reduce_while(%{keys: [], candidates: %{}, indicies: %{}, stop: nil}, &process_hash/2)
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.take(64)
    |> Enum.reverse
    |> hd
    |> IO.inspect
  end

  def process_hash({i, _} = item, %{keys: keys, stop: nil} = state) when length(keys) >= 64 do
    process_hash(item, %{state | stop: i + 1000})
  end

  def process_hash({i, _}, %{keys: keys, stop: stop}) when is_integer(stop) and i == stop do
    keys =
      keys
      |> Enum.sort_by(&elem(&1, 0))
      |> Enum.take(64)

    {:halt, keys}
  end

  def process_hash({index, hash}, state) do
    {threes, fives} = find_runs(hash)

    state =
      state
      |> remove_stale(index)
      |> find_valid_keys(fives)
      |> add_candidates(index, threes, hash)

    {:cont, state}
  end

  def find_runs(hash) do
    threes =
      hash
      |> String.codepoints
      |> Enum.chunk(3, 1)
      |> Stream.filter(&match?([a,a,a], &1))
      |> Stream.map(&hd/1)
      |> Enum.take(1)

    fives =
      hash
      |> String.codepoints
      |> Enum.chunk(5, 1)
      |> Enum.filter(&match?([a,a,a,a,a], &1))
      |> Enum.map(&hd/1)

    {threes, fives}
  end

  def remove_stale(state, index) when index < 1001, do: state

  def remove_stale(state, index) do
    remove_index(state, index - 1001)
  end

  def find_valid_keys(%{keys: keys, candidates: candidates} = state, fives) do
    valid_keys =
      fives
      |> Enum.flat_map(&Map.get(candidates, &1, []))
      |> Enum.uniq

    state = %{state | keys: Enum.concat(keys, valid_keys)}

    Enum.reduce(valid_keys, state, fn {i, _}, state ->
      remove_index(state, i)
    end)
  end

  def add_candidates(%{candidates: candidates, indicies: indicies} = state, index, threes, hash) do
    indicies = Map.put(indicies, index, threes)

    candidates = Enum.reduce(threes, candidates, fn key, candidates ->
      Map.update(candidates, key, [{index, hash}], fn values ->
        [{index, hash}|values]
      end)
    end)

    %{state | candidates: candidates, indicies: indicies}
  end

  def remove_index(%{candidates: candidates, indicies: indicies} = state, index) do
    {candidate_keys, indicies} = Map.pop(indicies, index, [])

    candidates = Enum.reduce(candidate_keys, candidates, fn key, candidates ->
      Map.update!(candidates, key, fn values ->
        Enum.reject(values, &match?({^index, _}, &1))
      end)
    end)

    %{state | indicies: indicies, candidates: candidates}
  end

  def hash(i) do
    Enum.reduce(0..2016, @input <> to_string(i), fn _, hash ->
      :md5
      |> :crypto.hash(hash)
      |> Base.encode16(case: :lower)
    end)
  end
end

Program.main
