use Mix.Config


config :master_proxy, 
  # any Cowboy options are allowed
  #http: [:inet6, port: 80],
  http: [:inet6, port: 4000],
#  http: [port: {:system, "PORT"}],
backends: [
    %{
      host: ~r/prova.stadler.no/,
     phoenix_endpoint: ProvaNoWeb.Endpoint
    },
    %{
      host: ~r/askapps.gigalixirapp.com/,
     phoenix_endpoint: ProvaNoWeb.Endpoint
    },
    %{
      host: ~r/stadler.stadler.no/,
     phoenix_endpoint: StadlerNoWeb.Endpoint
    },
    %{
      host: ~r/localhost/,
     phoenix_endpoint: StadlerNoWeb.Endpoint
    },
    ]

