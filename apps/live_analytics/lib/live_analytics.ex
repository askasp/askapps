defmodule LiveAnalytics do
  @moduledoc """
  Documentation for `LiveAnalytics`.
  """

  def data_from_ip(ip) do
    token = Application.get_env(:live_analytics, :ipinfo_api_key)
    {:ok, obj} = Tesla.get("https://ipinfo.io/#{ip}?token=#{token}")
    body = obj.body |> Jason.decode!()
  end

  def log_static_files_fetched_event(ip) do
    data_from_ip(ip)
    |> Map.delete("postal")
    |> Map.delete("bogon")
    |> string_map_to_atom_map
    |> Map.put(:stream_id, "analytics")
    |> Map.put(:utc, DateTime.utc_now() |> DateTime.to_string)
    |> (fn map -> struct(LiveAnalytics.Events.StaticFilesFetched, map) end).()
    |> (fn event -> OtpEs.put_event("analytics", event, -1) end).()
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
      defstruct [
        :stream_id,
        :utc,
        :ip,
        :city,
        :country,
        :loc,
        :region,
        :timezone,
        :org,
        :hostname,
        :readme
      ]
    end
  end

  defmodule ReadModels do
    defmodule VisitorsByCountry do
      defstruct [:country, :value]

      def get_instance_id(event) do
        case event.country do
          nil -> "UNKNOWN"
          x -> x
        end
      end

      def apply_event(nil, %Events.StaticFilesFetched{} = event),
        do: %VisitorsByCountry{country: event.country, value: 1}

      def apply_event(state, %LiveAnalytics.Events.StaticFilesFetched{} = event),
        do: %VisitorsByCountry{country: event.country, value: state.value + 1}
    end

  defmodule VisitorsByDate do
    defstruct [:date, :visitor_by_country]

    def get_instance_id(event), do: LiveAnalytics.datetime_to_date_string(event.utc)

    def apply_event(nil, %Events.StaticFilesFetched{} = event) do
     	date = LiveAnalytics.datetime_to_date_string(event.utc)
     	%VisitorsByDate{date: date, visitor_by_country: %{VisitorsByCountry.get_instance_id(event) => 1}}
    end

    def apply_event(%VisitorsByDate{} = state,  %LiveAnalytics.Events.StaticFilesFetched{} = event) do
        id = VisitorsByCountry.get_instance_id(event)
        value = state.visitor_by_country[id]
        	|> case do
            		nil -> 0
            		x -> x
            		end

        state.visitor_by_country
        |> Map.put(id, value + 1)
    	|> fn x -> %VisitorsByDate{state | visitor_by_country: x} end.()
    end

  end
  



  end

  defmodule AsyncLogRequest do
    import Plug.Conn

    def init(default), do: default

    def call(conn, _default) do
      Task.start(fn ->
        conn.remote_ip
        |> :inet_parse.ntoa()
        |> to_string()
        |> LiveAnalytics.log_static_files_fetched_event()
      end)

      conn
    end
  end

  def datetime_to_date_string(datetime) do
      datetime |> String.split(" ") |> Enum.at(0)
  end

end
