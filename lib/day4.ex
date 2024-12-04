defmodule Day4 do
  @directions [
    :n,
    :w,
    :s,
    :e,
    :nw,
    :ne,
    :sw,
    :se
  ]

  def part_one() do
    grid =
      read_input()
      |> to_grid()

    grid
    |> Enum.filter(&(elem(&1, 1) == ?X))
    |> Enum.into(%{})
    |> Map.keys()
    |> Enum.reduce(0, fn {x, y}, acc ->
      Enum.reduce(@directions, acc, fn dir, acc1 ->
        case get_neighbors(grid, x, y, 3, dir) do
          [?M, ?A, ?S] -> acc1 + 1
          _ -> acc1
        end
      end)
    end)
    |> IO.puts()
  end

  def part_two() do
    grid =
      read_input()
      |> to_grid()

    grid
    |> Enum.filter(&(elem(&1, 1) == ?A))
    |> Enum.into(%{})
    |> Map.keys()
    |> Enum.reduce(0, fn {x, y}, acc ->
      [ne] = get_neighbors(grid, x, y, 1, :ne)
      [se] = get_neighbors(grid, x, y, 1, :se)
      [nw] = get_neighbors(grid, x, y, 1, :nw)
      [sw] = get_neighbors(grid, x, y, 1, :sw)

      if(
        ([ne, sw] == [?M, ?S] || [ne, sw] == [?S, ?M]) &&
          ([nw, se] == [?M, ?S] || [nw, se] == [?S, ?M])
      ) do
        acc + 1
      else
        acc
      end
    end)
    |> IO.puts()
  end

  defp get_neighbors(grid, x, y, count, :n) do
    for i <- 1..count, do: Map.get(grid, {x, y - i})
  end

  defp get_neighbors(grid, x, y, count, :s) do
    for i <- 1..count, do: Map.get(grid, {x, y + i})
  end

  defp get_neighbors(grid, x, y, count, :e) do
    for i <- 1..count, do: Map.get(grid, {x + i, y})
  end

  defp get_neighbors(grid, x, y, count, :w) do
    for i <- 1..count, do: Map.get(grid, {x - i, y})
  end

  defp get_neighbors(grid, x, y, count, :nw) do
    for i <- 1..count, do: Map.get(grid, {x - i, y - i})
  end

  defp get_neighbors(grid, x, y, count, :sw) do
    for i <- 1..count, do: Map.get(grid, {x - i, y + i})
  end

  defp get_neighbors(grid, x, y, count, :ne) do
    for i <- 1..count, do: Map.get(grid, {x + i, y - i})
  end

  defp get_neighbors(grid, x, y, count, :se) do
    for i <- 1..count, do: Map.get(grid, {x + i, y + i})
  end

  defp to_grid(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {chars, y}, acc ->
      chars
      |> Enum.with_index()
      |> Enum.reduce(acc, fn
        {char, x}, acc1 ->
          Map.put(acc1, {x, y}, char)
      end)
    end)
  end

  defp read_input() do
    File.stream!("priv/day4.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_charlist/1)
    |> Enum.to_list()
  end
end
