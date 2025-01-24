defmodule PruebaTecnica.Core.Infrastructure.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :name, :string, null: false
      add :tenant_id, references(:tenants, on_delete: :delete_all), null: false
      timestamps()
    end

    create unique_index(:permissions, [:name, :tenant_id])
  end
end
