defmodule FlakyTest do
  use ExUnit.Case

  setup do
    start = Flaky.Servertime
    flakes = Enum.map 1..10_000, fn(_) -> Flaky.generate(62) end
    finish = Flaky.Server.time
    {:ok, [flakes: flakes, start: start, finish: finish]}
  end

  test "flakes are generated in sequence", %{flakes: flakes} do
    assert flakes == Enum.sort(flakes)
  end

  test "flakes are uniq", %{flakes: flakes} do
    assert flakes == Enum.uniq(flakes)
  end

  test "flakes generated quickly", %{flakes: flakes, start: start, finish: finish} do
    time = finish - start
    IO.puts "Time to generate #{Enum.count flakes} flakes: #{time} milliseconds."
    assert time <= 1000
  end

end
