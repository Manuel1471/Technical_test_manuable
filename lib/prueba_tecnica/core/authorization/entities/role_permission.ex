defmodule PruebaTecnica.Core.Authorization.RolePermission do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}  # Usar :id (entero) como clave primaria
  @foreign_key_type :id  # Usar :id (entero) para claves foráneas

  schema "role_permissions" do
    belongs_to :role, PruebaTecnica.Core.Authorization.Role
    belongs_to :permission, PruebaTecnica.Core.Authorization.Permission

    timestamps()  # Campos inserted_at y updated_at
  end

  @doc """
  Cambioset para crear o actualizar una relación rol-permiso.
  """
  def changeset(role_permission, attrs) do
    role_permission
    |> cast(attrs, [:role_id, :permission_id])
    |> validate_required([:role_id, :permission_id])
    |> unique_constraint([:role_id, :permission_id])  # Evitar duplicados
  end
end
