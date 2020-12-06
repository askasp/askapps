defmodule OtpAnalytics do
  @moduledoc """
  Documentation for `OtpAnalytics`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> OtpAnalytics.hello()
      :world

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
    |> string_map_to_atom_map
    |>Map.put(:stream_id, "analytics")
    |> fn map -> struct(Events.StaticFilesFetched, map)end.()
    |> fn event -> OtpEs.put_event("analytics",event, -1)end.()
    end
#
#  end

  def string_map_to_atom_map(inmap) do
  for {key, val} <- inmap, into: %{} do
  {String.to_existing_atom(key), val}
  end
end

  def hello do
    :world
  end
end

defmodule Events do
  defmodule StaticFilesFetched do
    @derive Jason.Encoder
    defstruct [:stream_id, :ip, :city, :country, :loc, :region, :timezone,:org, :postal, :hostname, :readme]
  end
end

