defmodule StadlerNo.MixProject do
  use Mix.Project

  def project do
    [
      app: :stadler_no,
      version: "0.0.3",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {StadlerNo.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.5"},
      {:phoenix_live_view, "~> 0.14.7"},
      {:floki, ">= 0.27.0", only: :test},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.3.2"},
      {:telemetry_metrics, "~> 0.4"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:telemetry_poller, "~> 0.4"},
      
      {:gettext, "~> 0.11"},
      {:typed_struct, "~> 0.2.1"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"}
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
        #|> bump_version()
#        |> to_string()


      x ->
        IO.inspect x
        "0.0.0-dev"
    end
  end

  defp bump_version(%Version{pre: []} = version) do
    IO.inspect "heiheihei"
    IO.inspect "heiheihei"
    IO.inspect "heiheihei"
    IO.inspect "heiheihei"
    IO.inspect "heiheihei"
    IO.inspect "heiheihei"
    IO.inspect "heiheihei"
    IO.inspect version
    version
    end

  defp bump_version(%Version{patch: p} = version) do
    IO.inspect "heiheihei"
    IO.inspect "heiheihei"
    IO.inspect "heiheihei"
    IO.inspect "heiheihei"
    IO.inspect "heiheihei"
    IO.inspect version
    struct(version, patch: p + 1)  
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "cmd npm install --prefix assets"]
    ]
  end
end
