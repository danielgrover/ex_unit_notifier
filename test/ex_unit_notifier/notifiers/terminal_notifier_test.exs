defmodule ExUnitNotifier.Notifiers.TerminalNotifierTest do
  use ExUnit.Case
  import ExUnitNotifier.Notifiers.TerminalNotifier

  describe "no sound configs" do
    test "with no config, there is no sound option" do
      assert Application.get_env(:ex_unit_notifier, :sound) == nil
      options = notify_options(:ok, "ok")
      refute "-sound" in options
    end
  end

  describe "with sound configs" do
    setup do
      Application.put_env(
        :ex_unit_notifier,
        :sound,
        ok: "good_sound",
        error: "bad_sound"
      )

      on_exit(fn ->
        Application.delete_env(:ex_unit_notifier, :sound)
      end)
    end

    @tag :pending
    test ":ok status and key exists, sound option present" do
      options = notify_options(:ok, "ok")
      assert "-sound" in options
      assert "good_sound" in options
    end

    test ":error status and key exists, sound option present" do
      options = notify_options(:error, "error")
      assert "-sound" in options
      assert "bad_sound" in options
    end

    test ":missing status but key does not exist, no sound option present" do
      options = notify_options(:missing, "missing")
      refute "-sound" in options
    end
  end
end
