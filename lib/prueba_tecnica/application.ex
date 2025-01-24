defmodule PruebaTecnica.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PruebaTecnicaWeb.Telemetry,
      PruebaTecnica.Core.Infrastructure.Repo,
      {DNSCluster, query: Application.get_env(:prueba_tecnica, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PruebaTecnica.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PruebaTecnica.Finch},
      # Start a worker by calling: PruebaTecnica.Worker.start_link(arg)
      # {PruebaTecnica.Worker, arg},
      # Start to serve requests, typically the last entry
      PruebaTecnicaWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PruebaTecnica.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PruebaTecnicaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
