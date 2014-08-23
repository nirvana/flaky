defmodule FlakyTest do
  use ExUnit.Case

  setup do
    start = Flaky.Server.time
    flakes = Enum.map 1..10_000, fn(_) -> Flaky.generate(62) end
    finish = Flaky.Server.time
    {:ok, [flakes: flakes, start: start, finish: finish]}
  end

  test "flakes generated quickly", %{start: start, finish: finish} do
    time = finish - start
    IO.puts "Time to generate 10,000 flakes: #{time} milliseconds."
    assert time <= 500
  end

  test "flakes are generated in sequence", %{flakes: flakes} do
    assert flakes == Enum.sort(flakes)
  end

  test "flakes are uniq", %{flakes: flakes} do
    assert flakes == Enum.uniq(flakes)
  end

end
