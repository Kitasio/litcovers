import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :litcovers, Litcovers.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "litcovers_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :litcovers, LitcoversWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "8RaXxnEultwRYiwH/qWgIM81nNIczutGBFYbN3m9auzOhXr+7yMEbRjYuBRthDuT",
  server: false

# In test we don't send emails.
config :litcovers, Litcovers.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
