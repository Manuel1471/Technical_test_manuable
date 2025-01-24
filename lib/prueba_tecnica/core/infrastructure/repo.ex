defmodule PruebaTecnica.Core.Infrastructure.Repo do
  use Ecto.Repo,
    otp_app: :prueba_tecnica,
    adapter: Ecto.Adapters.MyXQL
end
