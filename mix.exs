defmodule Askapps.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      app: :askapps,
      version: version(),
      start_permanent: Mix.env() == :prod,
      deps: deps()

    ]
  end


 defp version do
    case System.cmd(
           "git",
           ~w[describe --dirty=+dirty],
           stderr_to_stdout: true
         ) do
      {version, 0} ->
        version
        |> Version.parse()
        |> bump_version()
        |> to_string()

      _ ->
        "0.0.0-dev"
    end
  end

  defp bump_version(%Version{pre: []} = version), do: version

  defp bump_version(%Version{patch: p} = version),
    do: struct(version, patch: p + 1)
  

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [{:distillery, "~> 2.1"}]
  end
end
