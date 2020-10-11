use Mix.Config

config :master_proxy, 
  # any Cowboy options are allowed
  http: [:inet6, port: 4080],
  #https: [:inet6, port: 4443],
  backends: [
    %{
      host: ~r/stadler.prova.no/,
     phoenix_endpoint: ProvaNoWeb.Endpoint
    },
    %{
      host: ~r/stadler.stadler.no/,
     phoenix_endpoint: StadlerNoWeb.Endpoint
    },
    ]


import_config "#{Mix.env()}.exs"
