
defmodule LiveAnalytics.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Supervisor.child_spec({OtpCqrs.ReadModelAgent, read_model: LiveAnalytics.ReadModels.VisitorsByCountry}, id: :id1),
      Supervisor.child_spec({OtpCqrs.ReadModelAgent, read_model: LiveAnalytics.ReadModels.VisitorsByDate}, id: :id2)
      # Starts a worker by calling: LiveAnalytics.Worker.start_link(arg)
      # {LiveAnalytics.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveAnalytics.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
