use Mix.Config

config :master_proxy, 
  # any Cowboy options are allowed
  http: [:inet6, port: 80],
  https: [:inet6, port: 443],
  backends: [
    %{
      host: ~r/prova.stadler.no/,
     phoenix_endpoint: ProvaNoWeb.Endpoint
    },
    %{
      host: ~r/stadler.stadler.no/,
     phoenix_endpoint: StadlerNoWeb.Endpoint
    },
    ]

