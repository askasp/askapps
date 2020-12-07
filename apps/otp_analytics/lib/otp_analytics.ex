defmodule OtpAnalytics do
  @moduledoc """
  Documentation for `OtpAnalytics`.
  """


  def data_from_ip(ip) do
    token = Application.get_env(:otp_analytics, :ipinfo_api_key)
    {:ok, obj} = Tesla.get("https://ipinfo.io/#{ip}?token=#{token}")
    IO.inspect obj
    body = obj.body |> Jason.decode!
  end

  def log_static_files_fetched_event(ip) do
    data_from_ip(ip)
    |> IO.inspect
    |> Map.delete("postal")
    |> string_map_to_atom_map
    |>Map.put(:stream_id, "analytics")
    |>Map.put(:utc, DateTime.utc_now)
    |> fn map -> struct(OtpAnalytics.Events.StaticFilesFetched, map)end.()
    |> fn event -> OtpEs.put_event("analytics",event, -1)end.()
    end
#
#  end

  def string_map_to_atom_map(inmap) do
  for {key, val} <- inmap, into: %{} do
  {String.to_existing_atom(key), val}
  end
end


defmodule Events do
  defmodule StaticFilesFetched do
    @derive Jason.Encoder
    defstruct [:stream_id, :utc, :ip, :city, :country, :loc, :region, :timezone,:org, :hostname, :readme]
  end
end


defmodule ReadModels do
  defmodule VisitorsByCountry do
    defstruct [:country, :value]

    def get_instance_id(event), do: event.country

    def apply_event(nil, %Events.StaticFilesFetched{}= event),
      do: %VisitorsByCountry{country: event.country, value: 1}

    def apply_event(state, %OtpAnalytics.Events.StaticFilesFetched{}= event),
      do: %VisitorsByCountry{country: event.country, value: state.value + 1}

  end
end


end




