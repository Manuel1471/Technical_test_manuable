defmodule PruebaTecnica.Core.Tenants.UseCases.UseCasesTenants do
   @moduledoc """
  Módulo que encapsula la lógica de negocio relacionada con los inquilinos (tenants).
  """

  alias PruebaTecnica.Core.Interfaces.Repositories.TenantEntity

  @doc """
  Obtiene una lista de nombres de inquilinos (tenants).
  """
  def get_tenants do
    case TenantEntity.list_tenant() do
      [] -> {:error, nil}
      tenants -> {:ok, tenants}
    end
  end

  @doc """
  Obtiene un inquilino (tenant) por su ID, con sus asociaciones precargadas.
  """
  def get_tenant_by_id(id) do
    case TenantEntity.get_tenant_by_id(id) do
      nil -> {:error, :not_found}
      tenant -> {:ok, tenant}
    end
  end

  @doc """
  Crea un nuevo inquilino (tenant) en el sistema.
  """
  def create_tenant(attrs) do
    case TenantEntity.create_tenant(attrs) do
      {:ok, tenant} -> {:ok, tenant}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Actualiza un inquilino (tenant) existente en el sistema.
  """
  def update_tenant(tenant_id, attrs) do
    case TenantEntity.get_tenant_by_id(tenant_id) do
      nil ->
        {:error, :not_found}  # Devuelve un error si el tenant no existe

      tenant ->
        case TenantEntity.update_tenant(tenant, attrs) do
          {:ok, updated_tenant} ->
            {:ok, updated_tenant}  # Devuelve el tenant actualizado

          {:error, changeset} ->
            {:error, changeset}  # Devuelve errores de validación
        end
    end
  end

  @doc """
  Elimina un inquilino (tenant) del sistema.
  """
  def delete_tenant(tenant_id) do
    case TenantEntity.get_tenant_by_id(tenant_id) do
      nil -> {:error, :not_found}
      tenant -> TenantEntity.delete_tenant(tenant)
    end
  end

  @doc """
  Obtiene todos los inquilinos (tenants) con sus asociaciones precargadas.
  """
  def list_all_tenants do
    case TenantEntity.list_tenants_with_associations() do
      [] -> {:error, nil}
      tenants -> {:ok, tenants}
    end
  end
end
