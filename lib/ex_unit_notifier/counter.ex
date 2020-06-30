defmodule ExUnitNotifier.Counter do
  @moduledoc false

  defstruct tests: 0, failures: 0, skipped: 0, invalid: 0, excluded: 0

  def increment(counter, type) do
    type =
      case type do
        :failed -> :failures
        _ -> type
      end

    Map.update!(counter, type, fn val -> val + 1 end)
  end
end
