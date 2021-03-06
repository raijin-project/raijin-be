# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :raijin,
  ecto_repos: [Raijin.Repo]

# Configures the endpoint
config :raijin, RaijinWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3HvRn1BwxgLdHSxHuFlTsR5e/x4ZluGDdPyfXN899yFsxp7lhv79i08OxIUDndDA",
  render_errors: [view: RaijinWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Raijin.PubSub,
  live_view: [signing_salt: "jolejOT5"]

config :raijin, :generators,
  migration: false,
  binary_id: true,
  sample_binary_id: "11111111-1111-1111-1111-111111111111"


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
