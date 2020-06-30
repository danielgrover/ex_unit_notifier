defmodule ExUnitNotifierTest do
  use ExUnit.Case
  doctest ExUnitNotifier

  defmodule TestNotifier do
    def notify(status, message) do
      send(test_pid(), {status, message})
    end

    defp test_pid, do: Application.get_env(:ex_unit_notifier, :test_pid)
  end

  setup do
    Application.put_env(:ex_unit_notifier, :notifier, TestNotifier)
    Application.put_env(:ex_unit_notifier, :test_pid, self())

    on_exit(fn ->
      Application.delete_env(:ex_unit_notifier, :notifier)
    end)

    :ok
  end

  test "sends expected notification when tests are successful" do
    defmodule SuccessfulTests do
      use ExUnit.Case

      test "successful test" do
        assert 1 + 1 == 2
      end

      test "successful test 2" do
        assert 1 + 1 == 2
      end
    end

    run_sample_test()

    assert_receive {:ok, message}
    assert message =~ ~r(2 tests, 0 failures in \d+\.\d{2} seconds)
  end

  test "sends expected notification when tests contains failures" do
    defmodule TestsWithFailure do
      use ExUnit.Case

      test "successful test" do
        assert 1 + 1 == 2
      end

      test "failing test" do
        assert 1 + 1 == 3
      end
    end

    run_sample_test()

    assert_receive {:error, message}
    assert message =~ ~r(2 tests, 1 failures in \d+\.\d{2} seconds)
  end

  test "sends expected notification when tests raises an error" do
    defmodule TestsWithErrorRaised do
      use ExUnit.Case

      test "failing test" do
        raise ArgumentError
      end
    end

    run_sample_test()

    assert_receive {:error, message}
    assert message =~ ~r(1 tests, 1 failures in \d+\.\d{2} seconds)
  end

  test "sends expected notification when tests contain skipped test" do
    defmodule TestsWithSkip do
      use ExUnit.Case

      test "successful test" do
        assert 1 + 1 == 2
      end

      @tag :skip
      test "skipped test" do
        assert 1 + 1 == 3
      end
    end

    run_sample_test()

    assert_receive {:ok, message}
    assert message =~ ~r(2 tests, 0 failures, 1 skipped in \d+\.\d{2} seconds)
  end

  test "sends expected notification when tests contain pending test" do
    defmodule TestsWithPending do
      use ExUnit.Case

      test "successful test" do
        assert 1 + 1 == 2
      end

      @tag :pending
      test "pending test" do
        assert 1 + 1 == 3
      end
    end

    run_sample_test()

    assert_receive {:ok, message}
    # This now reports as "Excluded" to match UxUnit change in v1.7
    #    : https://github.com/elixir-lang/elixir/blob/v1.7/CHANGELOG.md
    assert message =~ ~r(2 tests, 0 failures, 1 excluded in \d+\.\d{2} seconds)
  end

  test "sends expected notification when tests contain pending and skipped tests" do
    defmodule TestsWithPendingAndSkipped do
      use ExUnit.Case

      @tag :skip
      test "successful test" do
        assert 1 + 1 == 2
      end

      @tag :pending
      test "pending test" do
        assert 1 + 1 == 3
      end
    end

    run_sample_test()

    assert_receive {:ok, message}
    # This now reports as "Excluded" to match UxUnit change in v1.7
    #    : https://github.com/elixir-lang/elixir/blob/v1.7/CHANGELOG.md
    assert message =~ ~r(2 tests, 0 failures, 1 excluded, 1 skipped in \d+\.\d{2} seconds)
  end

  defp run_sample_test do
    test_modules_loaded()

    ExUnit.configure(formatters: [ExUnitNotifier], exclude: [pending: true, skip: true])
    ExUnit.run()
  end

  if function_exported?(ExUnit.Server, :cases_loaded, 0) do
    defp test_modules_loaded, do: ExUnit.Server.cases_loaded()
  else
    defp test_modules_loaded, do: ExUnit.Server.modules_loaded()
  end
end
