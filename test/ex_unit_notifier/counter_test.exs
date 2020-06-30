defmodule ExUnitNotifier.CounterTest do
  use ExUnit.Case
  alias ExUnitNotifier.Counter

  def assert_all_counts_are_zero(counter, keys) do
    keys
    |> Enum.each(fn type ->
      assert Map.fetch!(counter, type) == 0
    end)
  end

  test "an empty Counter struct" do
    assert_all_counts_are_zero(%Counter{}, Counter.count_types())
  end

  describe "Counter.increment" do
    test "it increments by 1 the type provided" do
      Counter.count_types()
      |> Enum.each(fn type ->
        remaining = List.delete(Counter.count_types(), type)
        counter = Counter.increment(%Counter{}, type)
        assert Map.fetch!(counter, type) == 1
        assert_all_counts_are_zero(counter, remaining)
      end)
    end

    test "it will not error if a bad key is sent" do
      counter = Counter.increment(%Counter{}, :bad_type)
      assert_all_counts_are_zero(counter, Counter.count_types())
    end
  end
end
