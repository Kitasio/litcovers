defmodule CoverGen.Supervisor do
  use Supervisor
  require Logger

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    Logger.info("CoverGen.Supervisor init, pid: #{inspect(self())}")

    children = [
      CoverGen.Cleaner.ImageDeleter,
      CoverGen.DrippingMachine
    ]

    Supervisor.init(children,
      strategy: :one_for_one
    )
  end
end
