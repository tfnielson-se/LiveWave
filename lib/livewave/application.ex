defmodule Livewave.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    unless Mix.env == :prod do
      Dotenv.load
      Mix.Task.run("loadconfig")
    end
    children = [
      # Start the Telemetry supervisor
      LivewaveWeb.Telemetry,
      # Start the Ecto repository
      Livewave.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Livewave.PubSub},
      # Start the Endpoint (http/https)
      LivewaveWeb.Endpoint,
      # Start a worker by calling: Livewave.Worker.start_link(arg)
      # {Livewave.Worker, arg}
      LivewaveWeb.Presence
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Livewave.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LivewaveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
