defmodule ExUnitNotifier.CounterTest do
  use ExUnit.Case
  alias ExUnitNotifier.Counter

  @count_types ~w(failures tests skipped excluded invalid)a

  setup do
    [counter: %Counter{}]
  end

  def keys_are_zero(counter, keys) do
    keys
    |> Enum.each(fn type ->
      assert Map.fetch!(counter, type) == 0
    end)
  end

  test "an empty Counter struct", %{counter: counter} do
    keys_are_zero(counter, @count_types)
  end

  describe "Counter.increment" do
    test "it increments by 1 the type provided", %{counter: counter} do
      @count_types
      |> Enum.each(fn type ->
        remaining = List.delete(@count_types, type)
        counter = Counter.increment(counter, type)
        assert Map.fetch!(counter, type) == 1
        keys_are_zero(counter, remaining)
      end)
    end
  end
end
