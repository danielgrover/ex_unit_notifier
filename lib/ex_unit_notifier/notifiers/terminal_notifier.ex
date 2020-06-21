defmodule ExUnitNotifier.Notifiers.TerminalNotifier do
  @moduledoc false

  def notify(status, message) do
    System.cmd(executable(), notify_options(status, message))
  end

  def available?, do: executable() != nil

  def notify_options(status, message) do
    [
      "-group",
      "ex-unit-notifier",
      "-title",
      "ExUnit",
      "-message",
      message,
      "-appIcon",
      get_icon(status)
    ] ++ sound(Application.get_env(:ex_unit_notifier, :sound, [])[status])
  end

  defp executable, do: System.find_executable("terminal-notifier")

  defp get_icon(status),
    do: Application.app_dir(:ex_unit_notifier, "priv/icons/#{status |> Atom.to_string()}.icns")

  defp sound(name) when is_binary(name), do: ["-sound", name]
  defp sound(_), do: []
end
