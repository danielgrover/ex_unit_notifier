defmodule ExUnitNotifier.MessageFormatterTest do
  use ExUnit.Case
  doctest ExUnitNotifier

  import ExUnitNotifier.MessageFormatter
  alias ExUnitNotifier.Counter

  test "format/1 returns message with the correct numbers specified" do
    counter = %Counter{tests: 3, failures: 2}

    message = format(counter, 600_456, 100_000)

    assert message == "3 tests, 2 failures in 0.7 seconds"
  end

  test "format/1 returns message adds the number of skipped tests if tests were skipped" do
    counter = %Counter{tests: 3, failures: 2, skipped: 7}

    message = format(counter, 600_456, 100_000)

    assert message == "3 tests, 2 failures, 7 skipped in 0.7 seconds"
  end

  test "format/1 returns message adds the number of excluded tests if tests were excluded" do
    counter = %Counter{tests: 3, failures: 2, excluded: 7}

    message = format(counter, 600_456, 100_000)

    assert message == "3 tests, 2 failures, 7 excluded in 0.7 seconds"
  end

  test "format/1 returns message adds the number of excluded and skipped tests" do
    counter = %Counter{tests: 3, failures: 2, excluded: 7, skipped: 10}

    message = format(counter, 600_456, 100_000)

    assert message == "3 tests, 2 failures, 7 excluded, 10 skipped in 0.7 seconds"
  end
end
