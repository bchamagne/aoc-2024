defmodule Day3 do
  def part_one do
    ~r/mul\((\d{1,3}),(\d{1,3})\)/
    |> Regex.scan(read_input(), capture: :all_but_first)
    |> Enum.map(fn [a, b] ->
      String.to_integer(a) * String.to_integer(b)
    end)
    |> Enum.sum()
    |> IO.puts()
  end

  def part_two do
    read_input()
    |> tokenize()
    |> Enum.reduce(
      {0, :do},
      fn
        :TOKEN_DO, {acc, _} ->
          {acc, :do}

        :TOKEN_DONT, {acc, _} ->
          {acc, :dont}

        _, {acc, :dont} ->
          {acc, :dont}

        {:mul, a, b}, {acc, :do} ->
          {String.to_integer(a) * String.to_integer(b) + acc, :do}
      end
    )
    |> elem(0)
    |> IO.puts()
  end

  defp read_input() do
    File.read!("priv/day3.txt")
  end

  defp tokenize(bin, acc \\ [])
  defp tokenize("", acc), do: Enum.reverse(acc)
  defp tokenize("do()" <> rest, acc), do: tokenize(rest, [:TOKEN_DO | acc])
  defp tokenize("don't()" <> rest, acc), do: tokenize(rest, [:TOKEN_DONT | acc])

  defp tokenize("mul(" <> rest, acc) do
    case Regex.run(~r/^(\d{1,3}),(\d{1,3})\)/, rest, capture: :all_but_first) do
      [a, b] -> tokenize(rest, [{:mul, a, b} | acc])
      _ -> tokenize(rest, acc)
    end
  end

  defp tokenize(<<_::8, rest::binary>>, acc), do: tokenize(rest, acc)
end
