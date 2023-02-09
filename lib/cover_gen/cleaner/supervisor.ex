defmodule CoverGen.Cleaner.Supervisor do
  use Supervisor, restart: :temporary

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      CoverGen.Cleaner.ImageDeleter
    ]

    Supervisor.init(children,
      strategy: :one_for_one,
      max_seconds: :timer.seconds(30)
    )
  end
end
