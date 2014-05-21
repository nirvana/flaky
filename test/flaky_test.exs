defmodule FlakyTest do
  use ExUnit.Case

  setup do
    flakes = Enum.map 1..10_000, fn(_) -> Flaky.generate(62) end
    {:ok, [flakes: flakes]}
  end

  test "flakes are generated in sequence", %{flakes: flakes} do
    assert flakes == Enum.sort(flakes)
  end

  test "flakes are uniq", %{flakes: flakes} do
    assert flakes == Enum.uniq(flakes)
  end

end
