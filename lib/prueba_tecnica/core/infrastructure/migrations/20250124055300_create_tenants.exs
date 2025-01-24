defmodule PruebaTecnica.Core.Infrastructure.Repo.Migrations.CreateTenants do
  use Ecto.Migration

  def change do
    create table(:tenants) do
      add :name, :string, null: false
      timestamps()
    end

    create unique_index(:tenants, [:name])
  end
end
