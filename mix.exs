defmodule Askapps.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.1",
      start_permanent: Mix.env() == :prod,

      deps: deps(),
      releases: [
       askapps: [
       	applications: [
       	prova_no: :permanent,
       	stadler_no: :permanent,
       	proxy: :permanent,

       	],


       ]
      ]


    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [{:distillery, "~> 2.1"}]
  end
end
