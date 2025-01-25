defmodule PruebaTecnica.Core.Interfaces.Repositories.RoleEntity do

  import Ecto.Query
  alias PruebaTecnica.Core.Infrastructure.Repo
  alias PruebaTecnica.Core.Authorization.Role

  def create_role(attrs) do
    %Role{}
      |> Role.changeset(attrs)
      |> Repo.insert()
  end

  def get_role_by_id_and_tenant(role_id, tenant_id) do
    Repo.get_by(Role, id: role_id, tenant_id: tenant_id)
  end

  def update_role(role, attrs) do
    role
      |> Role.changeset(attrs)
      |> Repo.update()
  end

  def delete_role(role) do
    Repo.delete(role)
  end

  def list_roles_by_tenant(tenant_id) do
    Role
      |> where(tenant_id: ^tenant_id)
      |> select([p], map(p, [:id, :name, :description, :tenant_id, :inserted_at, :updated_at]))
      |> Repo.all()
  end

  @doc """
  Verifica si todos los roles existen.
  Devuelve una lista de los IDs de roles que no existen.
  """
  def check_roles_exist(role_ids) do
    existing_role_ids =
      Role
      |> where([r], r.id in ^role_ids)
      |> select([r], r.id)
      |> Repo.all()

    # Encuentra los IDs que no existen
    Enum.filter(role_ids, &(&1 not in existing_role_ids))
  end
end
