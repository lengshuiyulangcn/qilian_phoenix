# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :qilian_phoenix,
  ecto_repos: [QilianPhoenix.Repo]

# Configures the endpoint
config :qilian_phoenix, QilianPhoenix.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8luO5+TyuPXOSyOa0oduBuAXB3pXm0Yrpy5qQICF8qm70HO5aH1nBAAN/3b9JE3X",
  render_errors: [view: QilianPhoenix.ErrorView, accepts: ~w(html json)],
  pubsub: [name: QilianPhoenix.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
