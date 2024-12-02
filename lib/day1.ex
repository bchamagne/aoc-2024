defmodule Day1 do
  @doc """
  Pair up the smallest number in the left list with the smallest number in the right list, then the second-smallest left number with the second-smallest right number, and so on.
  Within each pair, figure out how far apart the two numbers are; you'll need to add up all of those distances.
  """
  def part_one() do
    {lefts, rights} = read_lists()

    [Enum.sort(lefts), Enum.sort(rights)]
    |> Enum.zip()
    |> Enum.map(&Utils.distance/1)
    |> Enum.sum()
    |> IO.puts()
  end

  @doc """
  Calculate a total similarity score by adding up each number in the left list after multiplying it by the number of times that number appears in the right list.
  """
  def part_two() do
    {lefts, rights} = read_lists()

    lefts
    |> Enum.map(fn l ->
      l * Enum.count(rights, &(&1 == l))
    end)
    |> Enum.sum()
    |> IO.puts()
  end

  defp read_lists() do
    File.stream!("priv/day1.txt")
    |> Stream.map(fn line ->
      [_, l, r] = Regex.run(~r/(\d*)\s*(\d*)/, line)
      {String.to_integer(l), String.to_integer(r)}
    end)
    |> Enum.unzip()
  end
end
