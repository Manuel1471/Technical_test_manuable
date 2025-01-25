defmodule PruebaTecnica.Core.Interfaces.Repositories.PermissionEntity do

  import Ecto.Query
  alias PruebaTecnica.Core.Infrastructure.Repo
  alias PruebaTecnica.Core.Authorization.Permission

  def create_permission(attrs) do
    %Permission{}
      |> Permission.changeset(attrs)
      |> Repo.insert()
  end

  def get_permission_by_id_and_tenant(permission_id, tenant_id) do
    Repo.get_by(Permission, id: permission_id, tenant_id: tenant_id)
  end

  def update_permission(permission, attrs) do
    permission
      |> Permission.changeset(attrs)
      |> Repo.update()
  end

  def delete_permission(permission) do
    Repo.delete(permission)
  end

  def list_permissions_by_tenant(tenant_id) do
    Permission
      |> where(tenant_id: ^tenant_id)
      |> select([p], map(p, [:id, :name, :description, :tenant_id, :inserted_at, :updated_at]))
      |> Repo.all()
  end
end
