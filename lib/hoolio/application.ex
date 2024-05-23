defmodule Hoolio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HoolioWeb.Telemetry,
      Hoolio.Repo,
      {DNSCluster, query: Application.get_env(:hoolio, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Hoolio.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Hoolio.Finch},
      # Start a worker by calling: Hoolio.Worker.start_link(arg)
      # {Hoolio.Worker, arg},
      # Start to serve requests, typically the last entry
      HoolioWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hoolio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HoolioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
