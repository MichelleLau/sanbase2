use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :sanbase, SanbaseWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    yarn: [
      "start",
      cd: Path.expand("../app", __DIR__)
    ],
    node: [
      "node_modules/brunch/bin/brunch",
      "watch",
      "--stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# command from your terminal:
#
#     openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -keyout priv/server.key -out priv/server.pem
#
# The `http:` config above can be replaced with:
#
#     https: [port: 4000, keyfile: "priv/server.key", certfile: "priv/server.pem"],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :sanbase, Sanbase.Repo,
  username: "postgres",
  password: "postgres",
  database: "sanbase_dev",
  hostname: "localhost"

config :sanbase, Sanbase.ClickhouseRepo,
  pool: Ecto.Adapters.SQL.Sandbox,
  adapter: Ecto.Adapters.Postgres,
  database: "clickhouse_test",
  hostname: "localhost",
  port: 5432,
  username: "postgres",
  password: "postgres"

config :ex_admin,
  basic_auth: [
    username: "admin",
    password: "admin",
    realm: "Admin Area"
  ]

config :sanbase, Sanbase.ExternalServices.Etherscan.RateLimiter,
  scale: 1000,
  limit: 5,
  time_between_requests: 250

config :sanbase, SanbaseWeb.Graphql.ContextPlug,
  basic_auth_username: "user",
  basic_auth_password: "pass"

config :arc,
  storage: Arc.Storage.Local,
  storage_dir: "/tmp/sanbase/filestore/"

if File.exists?("config/dev.secret.exs") do
  import_config "dev.secret.exs"
end
