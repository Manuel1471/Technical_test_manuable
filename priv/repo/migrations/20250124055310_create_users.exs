defmodule PruebaTecnica.Core.Infrastructure.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :tenant_id, references(:tenants, on_delete: :delete_all), null: false
      timestamps()
    end

    create unique_index(:users, [:email, :tenant_id])
  end
end
