defmodule LiveAnalyticsWeb.PageLive do
  use LiveAnalyticsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do

      start = ~D[2020-12-20]
      x = hits_per_day_from_date(start)
      y = Date.range(start, now_string()) |> Enum.map(fn date -> Date.to_string(date)  end)

    {:ok, assign(socket, hits_per_day_data: x, hits_per_day_label: y, today: today(), all_time: all_time(), this_week: this_week(), this_month: this_month())}
  end

  def render(assigns) do
    ~L"""

    <h1 class="text-stadler text-2xl"> Analytics </h1>
    <hr class="border-solid border-stadler"> </hr>
    <table class="w-full  mt-5 text-white border-collapse opacity-67">
    <tr class="text-left">
      <th >Country </th>
      <th> Today </th>
      <th> This week  </th>
      <th> This month  </th>
      <th> All Time </th>
    </tr>

    <%= for {key, value} <- @all_time do %>
      <tr class="">
      <td> <%= key %> </td>
      <td> <%= @today[key] %> </td>
      <td> <%= @this_week[key] %> </td>
      <td> <%= @this_month[key] %> </td>
      <td> <%= @all_time[key] %> </td>
    </tr>
    <% end %>


    </table>

<script src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4/dist/Chart.min.js"></script>

<div phx-update=ignore class=mt-5>
<canvas  id="myChart" width="400" height="400"></canvas>
<script phx-ignore=true>
var ctx = document.getElementById('myChart').getContext('2d');

var chart = new Chart(ctx, {
    // The type of chart we want to create
    type: 'line',

    // The data for our dataset
    data: {
        labels: <%= raw(Jason.encode!(@hits_per_day_label) )%> ,
        datasets: [{
            label: 'Visitors per date',
            borderColor: '#565ef4',

            data: <%= Jason.encode!(@hits_per_day_data) %>
        }]
    },

    // Configuration options go here
    options: {}
});

</script>
</div>
    """
  end


  def this_week() do
      now = now_string()
    start = Date.beginning_of_week(now, :monday)
    hits_from_range(start,now)
  end

  def today() do
      now = now_string()
    hits_from_range(now,now)
  end

  def this_month() do
      now = now_string()
    start = Date.beginning_of_month(now)
    hits_from_range(start,now)
  end

  def all_time() do
    now = now_string()
    start = ~D[2020-12-12]
    hits_from_range(start,now)

  end


  def hits_per_day_from_date(start) do
    now = now_string()
    dates = Date.range(start, now) |> Enum.map(fn date -> Date.to_string(date) end)
    Enum.reduce(dates, [],fn date, acc ->
      OtpCqrs.ReadModelAgent.get(LiveAnalytics.ReadModels.VisitorsByDate, date)
     |> sum_map()
     |> fn (x) -> acc ++ [x] end.()
     end
     )

  end

  def sum_map(nil), do: 0
  def sum_map(map), do: Enum.reduce(map.visitor_by_country, 0, fn({_k, v}, acc) -> v + acc end)

  def now_string() do
      DateTime.utc_now()
      |> DateTime.to_string()
      |> LiveAnalytics.datetime_to_date_string()
      |> Date.from_iso8601!()
  end

  def hits_from_range(start, week_end) do
    dates = Date.range(start, week_end) |> Enum.map(fn date -> Date.to_string(date) end)

    Enum.reduce(dates, %{}, fn date, acc ->
      OtpCqrs.ReadModelAgent.get(LiveAnalytics.ReadModels.VisitorsByDate, date)
      |> accumulate_results(acc)
    end)
  end


  def accumulate_results(nil, acc), do: acc
  def accumulate_results(state, acc) do
        for {key, value} <- (state.visitor_by_country) do
          Map.put(acc, key, nil_to_zero(acc[key]) + nil_to_zero(value))
        end
        |> Enum.at(0)
  end

  defp nil_to_zero(nil), do: 0
  defp nil_to_zero(x), do: x
end
