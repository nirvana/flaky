defmodule Flaky.I2l do

  def to_list(int, 10) do
    :erlang.integer_to_list(int)
  end

  def to_list(int, base)
    when is_integer(int) and is_integer(base) and base >= 2 and base <= 62 do
    cond do
      int < 0 ->
        [?- | to_list(-int, base, [])]
      true ->
        to_list(int, base, [])
    end
  end

  def to_list(_, _) do
    {:error_int_and_base_must_be_integer_and_base_between_2_and_62}
  end

  def to_list(int0, base, r0) do
    d = rem(int0, base)
    int1 = div(int0, base)
    r1 = cond do
      d >= 36 ->
        [d-36+?a|r0]
      d >= 10 ->
        [d-10+?A|r0]
      true ->
        [d+?0|r0]
    end
    cond do
      int1 === 0 ->
        r1
      true ->
        to_list(int1, base, r1)
    end
  end

end