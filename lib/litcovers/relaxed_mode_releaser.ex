defmodule Litcovers.RelaxedModeReleaser do
  alias Litcovers.Media
  alias Litcovers.Accounts
  require Logger
  use Task, restart: :transient

  def start_link(_arg) do
    Task.start_link(&loop/0)
  end

  defp loop do
    Logger.info("Relaxed mode releaser started")

    Accounts.list_users_with_recent_generations()
    |> Enum.map(fn user ->
      release(user)
    end)

    Process.sleep(:timer.minutes(30))
    loop()
  end

  defp release(user) do
    last_image = Media.last_image(user)

    if last_image.created_at > hour_ago() do
      params = %{recent_generations: 0}
      Accounts.update_relaxed_mode(user, params)
    end
  end

  defp hour_ago do
    NaiveDateTime.add(Timex.now(), -1, :hour)
  end
end
