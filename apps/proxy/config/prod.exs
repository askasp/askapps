use Mix.Config

config :master_proxy, 
  # any Cowboy options are allowed
  http: [:inet6, port: 80],
  https: [:inet6, port: 443],
  backends: [
    %{
      host: ~r/askapps.gigalixirapp.com/,
     phoenix_endpoint: ProvaNoWeb.Endpoint
    },
    %{
      host: ~r/stadler.askapps.gigalixirapp.com/,
     phoenix_endpoint: StadlerNoWeb.Endpoint
    },
    ]

