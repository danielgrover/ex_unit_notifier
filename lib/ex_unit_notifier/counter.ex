defmodule ExUnitNotifier.Counter do
  @moduledoc false

  defstruct tests: 0, failures: 0, skipped: 0, invalid: 0, excluded: 0

  def count_types do
    %__MODULE__{} |> Map.delete(:__struct__) |> Map.keys()
  end

  def increment(counter, type) do
    type =
      case type do
        :failed -> :failures
        _ -> type
      end

    try do
      Map.update!(counter, type, fn val -> val + 1 end)
    rescue
      _ in KeyError -> counter
      e -> raise(e)
    end
  end
end
