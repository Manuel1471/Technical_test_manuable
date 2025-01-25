defmodule PruebaTecnica.Core.Interfaces.Repositories.TenantEntity do

  import Ecto.Query
  alias PruebaTecnica.Core.Infrastructure.Repo
  alias PruebaTecnica.Core.Tenants.Tenant

  @doc """
  Obtiene todos los inquilinos (tenants).
  """
  def list_tenant() do
    query = from t in Tenant, select: %{id: t.id, name: t.name}
    Repo.all(query)
  end

  @doc """
  Obtiene todos los nombres de los inquilinos (tenants).
  """
  def list_tenant_names() do
    query = from t in Tenant, select: %{id: t.id, name: t.name}
    Repo.all(query)
  end

  @doc """
  Obtiene todos los inquilinos (tenants) con sus asociaciones precargadas.
  """
  def list_tenants_with_associations() do
    Tenant
    |> Repo.all()
    |> Repo.preload([:users, :roles, :permissions])
  end

  @doc """
  Obtiene un inquilino (tenant) por su ID, con sus asociaciones precargadas.
  """
  def get_tenant_by_id(id) do
    Tenant
    |> Repo.get(id)
    |> Repo.preload([:users, :roles, :permissions])
  end

  @doc """
  Crea un nuevo inquilino (tenant) en la base de datos.
  """
  def create_tenant(attrs) do
    %Tenant{}
    |> Tenant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Actualiza un inquilino (tenant) existente en la base de datos.
  """
  def update_tenant(%Tenant{} = tenant, attrs) do
    tenant
    |> Tenant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Elimina un inquilino (tenant) de la base de datos.
  """
  def delete_tenant(%Tenant{} = tenant) do
    Repo.delete(tenant)
  end

end
