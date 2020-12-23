defmodule Askapps.MixProject do

  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps()

    ]
  end
  
 def version do
    case System.cmd(
           "git",
           ["rev-list", "--count", "master"],
           stderr_to_stdout: true
         ) do
      {version, 0} ->
        version
        |> String.replace("\n", "")
        |> fn x -> "0.0.#{x}" end.()




      x ->
        IO.inspect x
        "0.0.0-dev"
    end
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
