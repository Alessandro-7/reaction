defmodule Reaction do

  @spec run(String.t(), map(), integer()) :: integer()
  def run(formula, rules, n) do
    pairs = initial_count(formula)
    rules = new_rules(rules)
    first_sym = String.first(formula)
    last_sym = String.last(formula)

    count_pairs(rules, n, pairs)
    |> count_symbols(first_sym, last_sym)
    |> count_power()
  end

  @spec count_pairs(map(), integer, map()) :: map()
  defp count_pairs(_rules, 0, pairs) do
    Enum.reduce(pairs, %{}, fn {[first | [last]], count}, acc ->
      Map.update(acc, first, count, fn v -> v + count end)
      |> Map.update(last, count, fn v -> v + count end)
    end)
  end
  defp count_pairs(rules, step, pairs) do
    new_pairs =
      Enum.reduce(pairs, %{}, fn {[first | last] = key, value}, acc ->
        middle = Map.get(rules, key)
        Map.update(acc, [first | [middle]], value, fn v -> v + value end)
        |> Map.update([middle | last], value, fn v -> v + value end)
      end)

    count_pairs(rules, step - 1, new_pairs)
  end

  @spec count_symbols(map(), String.t(), String.t()) :: map()
  defp count_symbols(raw_counters, first_sym, last_sym) do
    Enum.map(raw_counters, fn
      {^first_sym, v} -> {first_sym, div(v, 2) + 1}
      {^last_sym, v}  -> {last_sym, div(v, 2) + 1}
      {k, v}          -> {k, div(v, 2)}
    end)
    |> Map.new()
  end

  @spec count_power(map()) :: integer()
  defp count_power(counters) do
    {{_sym1, min}, {_sym2, max}} = Enum.min_max_by(counters, fn {_k, v} -> v end)
    max - min
  end

  @spec new_rules(map()) :: map()
  defp new_rules(rules) do
    Enum.map(rules, fn {k, v} -> {String.graphemes(k), v} end)
    |> Map.new()
  end

  @spec initial_count(String.t()) :: map()
  defp initial_count(formula) do
    formula
    |> String.graphemes()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.frequencies()
  end
end
