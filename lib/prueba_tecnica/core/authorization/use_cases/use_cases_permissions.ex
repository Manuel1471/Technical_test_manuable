defmodule PruebaTecnica.Core.Authorization.UseCases.UseCasesPermissions do

  alias PruebaTecnica.Core.Interfaces.Repositories.PermissionEntity
  alias PruebaTecnica.Core.Interfaces.Repositories.TenantEntity

  @doc """
  Crea un nuevo permiso para un tenant.
  """
  def create_permission(tenant_id, attrs) do
    # Verificar que el tenant exista
    case TenantEntity.get_tenant_by_id(tenant_id) do
      nil ->
        {:error, :tenant_not_found}  # Devuelve un error si el tenant no existe

      _tenant ->
        # Si el tenant existe, crear el permiso
        PermissionEntity.create_permission(attrs)
    end
  end

  def get_permissions_by_tenant(tenant_id) do
    # Verificar que el tenant exista
    case TenantEntity.get_tenant_by_id(tenant_id) do
      nil ->
        {:error, :tenant_not_found}  # Devuelve un error si el tenant no existe

      _tenant ->
        {:ok, PermissionEntity.list_permissions_by_tenant(tenant_id)}
    end
  end

  @doc """
  Actualiza un permiso existente para un tenant.
  """
  def update_permission(tenant_id, permission_id, attrs) do
    # Verificar que el tenant exista
    case TenantEntity.get_tenant_by_id(tenant_id) do
      nil ->
        {:error, :tenant_not_found}  # Devuelve un error si el tenant no existe

      _tenant ->
        # Verificar que el permiso exista y pertenezca al tenant
        case PermissionEntity.get_permission_by_id_and_tenant(permission_id, tenant_id) do
          nil ->
            {:error, :permission_not_found}  # Devuelve un error si el permiso no existe

          permission ->
            # Si el permiso existe, intentar actualizarlo
            PermissionEntity.update_permission(permission, attrs)
        end
    end
  end

  @doc """
  Elimina un permiso existente para un tenant.
  """
  def delete_permission(tenant_id, permission_id) do
    # Verificar que el tenant exista
    case TenantEntity.get_tenant_by_id(tenant_id) do
      nil ->
        {:error, :tenant_not_found}  # Devuelve un error si el tenant no existe

      _tenant ->
        # Verificar que el permiso exista y pertenezca al tenant
        case PermissionEntity.get_permission_by_id_and_tenant(permission_id, tenant_id) do
          nil ->
            {:error, :permission_not_found}  # Devuelve un error si el permiso no existe

          permission ->
            # Si el permiso existe, intentar eliminarlo
            PermissionEntity.delete_permission(permission)
        end
    end
  end
end
