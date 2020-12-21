# This file is responsible for configuring your umbrella
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#


import_config "../apps/proxy/config/config.exs"
import_config "../apps/stadler_no/config/config.exs"
import_config "../apps/prova_no/config/config.exs"

config :otp_es, nodes: []


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

config :goth, json: {:system, "GCP_CREDENTIALS"}


import_config "#{Mix.env()}.exs"

config :logger, :level, :all
