
 defmodule Mix.Tasks.Compile.Gleam do
  use Mix.Task.Compiler

  def run(_args) do
    case Mix.shell().cmd("../mix_gleam/gleam build .") do
      0 -> {:ok, []}
      status -> exit(status)
    end
  end
end
