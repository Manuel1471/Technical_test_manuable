defmodule PruebaTecnica.Core.Interfaces.Repositories.RolePermissionEntity do
  import Ecto.Query
  alias PruebaTecnica.Core.Infrastructure.Repo
  alias PruebaTecnica.Core.Authorization.RolePermission
  alias PruebaTecnica.Core.Authorization.Permission

  @doc """
  Asocia un permiso a un rol.
  """
  def add_permission_to_role(role_id, permission_id) do
    %RolePermission{}
    |> RolePermission.changeset(%{role_id: role_id, permission_id: permission_id})
    |> Repo.insert()
  end

  @doc """
  Asocia multiples permisos a un rol.
  """
  def add_permissions_to_role(role_id, permission_ids) do
    now = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

    # Preparamos los datos para la inserción masiva
    records =
      Enum.map(permission_ids, fn permission_id ->
        %{
          role_id: role_id,
          permission_id: permission_id,
          inserted_at: now,
          updated_at: now
        }
      end)

    Repo.insert_all(RolePermission, records)
  end

  @doc """
  Desasocia un permiso de un rol.
  """
  def remove_permission_from_role(role_id, permission_id) do
    case Repo.delete_all(
      from(rp in RolePermission,
        where: rp.role_id == ^role_id and rp.permission_id == ^permission_id
      )
    ) do
      {0, _} ->
        {:error, :permission_not_associated}

      {num_rows, _} ->
        {:ok, num_rows}
    end
  end

  @doc """
  Lista los permisos asociados a un rol, incluyendo el nombre y descripción de cada permiso.
  """
  def list_permissions_by_role(role_id) do
    query =
      from(rp in RolePermission,
        join: p in Permission, on: rp.permission_id == p.id,
        where: rp.role_id == ^role_id,
        select: %{
          permission_id: rp.permission_id,
          name: p.name,
          description: p.description
        }
      )

    Repo.all(query)
  end
end
