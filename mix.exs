defmodule Decimex.Mixfile do
  use Mix.Project

  def project do
    [ app: :decimex,
      version: "0.0.1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [applications: %w(decimal)]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [{:decimal, "0.2.0", [github: "tim/erlang-decimal", tag: "v0.2.0"]}]
  end
end
