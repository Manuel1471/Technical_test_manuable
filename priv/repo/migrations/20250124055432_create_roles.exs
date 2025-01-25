defmodule PruebaTecnica.Core.Infrastructure.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string, null: false
      add :description, :string, null: true
      add :tenant_id, references(:tenants, on_delete: :delete_all), null: false
      timestamps()
    end

    create unique_index(:roles, [:name, :tenant_id])
  end
end
