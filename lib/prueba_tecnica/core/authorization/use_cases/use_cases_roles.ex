defmodule PruebaTecnica.Core.Authorization.UseCases.UseCasesRoles do

  alias PruebaTecnica.Core.Interfaces.Repositories.RoleEntity
  alias PruebaTecnica.Core.Interfaces.Repositories.TenantEntity
  alias PruebaTecnica.Core.Interfaces.Repositories.RolePermissionEntity

  @doc """
  Crea un nuevo rol para un tenant.
  """
  def create_role(tenant_id, attrs) do
    # Verificar que el tenant exista
    case TenantEntity.get_tenant_by_id(tenant_id) do
      nil ->
        {:error, :tenant_not_found}  # Devuelve un error si el tenant no existe

      _tenant ->
        # Si el tenant existe, crear el rol
        RoleEntity.create_role(Map.put(attrs, "tenant_id", tenant_id))
    end
  end

 @doc """
  Actualiza un rol existente para un tenant.
  """
  def update_role(tenant_id, role_id, attrs) do
    # Verificar que el tenant exista
    case TenantEntity.get_tenant_by_id(tenant_id) do
      nil ->
        {:error, :tenant_not_found}  # Devuelve un error si el tenant no existe

      _tenant ->
        # Verificar que el rol exista y pertenezca al tenant
        case RoleEntity.get_role_by_id_and_tenant(role_id, tenant_id) do
          nil ->
            {:error, :role_not_found}  # Devuelve un error si el rol no existe

          role ->
            # Si el rol existe, intentar actualizarlo
            RoleEntity.update_role(role, attrs)
        end
    end
  end

  @doc """
  Elimina un rol existente para un tenant.
  """
  def delete_role(tenant_id, role_id) do
    # Verificar que el tenant exista
    case TenantEntity.get_tenant_by_id(tenant_id) do
      nil ->
        {:error, :tenant_not_found}  # Devuelve un error si el tenant no existe

      _tenant ->
        # Verificar que el rol exista y pertenezca al tenant
        case RoleEntity.get_role_by_id_and_tenant(role_id, tenant_id) do
          nil ->
            {:error, :role_not_found}  # Devuelve un error si el rol no existe

          role ->
            # Si el rol existe, intentar eliminarlo
            RoleEntity.delete_role(role)
        end
    end
  end

  @doc """
  Lista todos los roles de un tenant.
  """
  def list_roles_by_tenant(tenant_id) do
    # Verificar que el tenant exista
    case TenantEntity.get_tenant_by_id(tenant_id) do
      nil ->
        {:error, :tenant_not_found}  # Devuelve un error si el tenant no existe

      _tenant ->
        # Si el tenant existe, listar los roles
        {:ok, RoleEntity.list_roles_by_tenant(tenant_id)}
    end
  end

  @doc """
  Asocia un permiso a un rol.
  """
  def add_permission_to_role(tenant_id, role_id, permission_id) do
    # Verificar que el tenant exista
    case TenantEntity.get_tenant_by_id(tenant_id) do
      nil ->
        {:error, :tenant_not_found}  # Devuelve un error si el tenant no existe

      _tenant ->
        # Verificar que el rol exista y pertenezca al tenant
        case RoleEntity.get_role_by_id_and_tenant(role_id, tenant_id) do
          nil ->
            {:error, :role_not_found}  # Devuelve un error si el rol no existe

          _role ->
            # Asociar el permiso al rol
            RolePermissionEntity.add_permission_to_role(role_id, permission_id)
        end
    end
  end

  @doc """
  Desasocia un permiso de un rol.
  """
  def remove_permission_from_role(tenant_id, role_id, permission_id) do
    # Verificar que el tenant exista
    case TenantEntity.get_tenant_by_id(tenant_id) do
      nil ->
        {:error, :tenant_not_found}  # Devuelve un error si el tenant no existe

      _tenant ->
        # Verificar que el rol exista y pertenezca al tenant
        case RoleEntity.get_role_by_id_and_tenant(role_id, tenant_id) do
          nil ->
            {:error, :role_not_found}  # Devuelve un error si el rol no existe

          _role ->
            # Desasociar el permiso del rol
            RolePermissionEntity.remove_permission_from_role(role_id, permission_id) |> IO.inspect()
        end
    end
  end

  @doc """
  Lista los permisos asociados a un rol.
  """
  def list_permissions_by_role(tenant_id, role_id) do
    # Verificar que el tenant exista
    case TenantEntity.get_tenant_by_id(tenant_id) do
      nil ->
        {:error, :tenant_not_found}  # Devuelve un error si el tenant no existe

      _tenant ->
        # Verificar que el rol exista y pertenezca al tenant
        case RoleEntity.get_role_by_id_and_tenant(role_id, tenant_id) do
          nil ->
            {:error, :role_not_found}  # Devuelve un error si el rol no existe

          _role ->
            # Listar los permisos asociados al rol
            {:ok, RolePermissionEntity.list_permissions_by_role(role_id)}
        end
    end
  end

  @doc """
  Asocia múltiples permisos a un rol.
  """
  def add_permissions_to_role(tenant_id, role_id, permission_ids) do
    # Verificar que el tenant exista
    case TenantEntity.get_tenant_by_id(tenant_id) do
      nil ->
        {:error, :tenant_not_found}  # Devuelve un error si el tenant no existe

      _tenant ->
        # Verificar que el rol exista y pertenezca al tenant
        case RoleEntity.get_role_by_id_and_tenant(role_id, tenant_id) do
          nil ->
            {:error, :role_not_found}  # Devuelve un error si el rol no existe

          _role ->
            # Asociar los permisos al rol
            RolePermissionEntity.add_permissions_to_role(role_id, permission_ids)
            {:ok, nil}
        end
    end
  end
end
