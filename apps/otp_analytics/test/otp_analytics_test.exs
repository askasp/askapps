defmodule OtpAnalyticsTest do
  use ExUnit.Case
  doctest OtpAnalytics

  test "Get and Store ip" do
    assert OtpAnalytics.log_static_files_fetched_event("89.10.223.166") == :ok

    a = OtpCqrs.ReadModelAgent.start_link([read_model: OtpAnalytics.ReadModels.VisitorsByCountry])
    :timer.sleep(1000)

    assert OtpCqrs.ReadModelAgent.get(OtpAnalytics.ReadModels.VisitorsByCountry, "NO") == %OtpAnalytics.ReadModels.VisitorsByCountry{country: "NO", value: 1}
             country: "NO",
             value: 1
           }
  
  end
