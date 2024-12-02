defmodule Day2 do
  @doc """
  The levels are either all increasing or all decreasing.
  Any two adjacent levels differ by at least one and at most three.
  """
  def part_one do
    read_reports()
    |> Enum.filter(&safe?/1)
    |> Enum.count()
    |> IO.puts()
  end

  @doc """
  Now, the same rules apply as before, except if removing a single level from an unsafe report would make it safe, the report instead counts as safe.
  """
  def part_two do
    read_reports()
    |> Enum.filter(fn levels ->
      1..length(levels)
      |> Enum.any?(fn i ->
        levels
        |> List.delete_at(i - 1)
        |> safe?()
      end)
    end)
    |> Enum.count()
    |> IO.puts()
  end

  defp safe?([first | rest = [second | _]]) do
    Enum.reduce_while(rest, {first, status(second, first)}, fn level, {previous_level, status} ->
      case {Utils.distance(level, previous_level), status(level, previous_level)} do
        {d, ^status} when d >= 1 and d <= 3 ->
          {:cont, {level, status}}

        _ ->
          {:halt, false}
      end
    end)
    |> then(fn
      false -> false
      _ -> true
    end)
  end

  defp status(a, b) when a > b, do: :incr
  defp status(_, _), do: :decr

  defp read_reports() do
    File.stream!("priv/day2.txt")
    |> Stream.map(fn line ->
      line
      |> String.split(~r/\s/, trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
