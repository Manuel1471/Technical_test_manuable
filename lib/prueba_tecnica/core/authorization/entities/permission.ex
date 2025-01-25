defmodule PruebaTecnica.Core.Authorization.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}  # Usar :id (entero) como clave primaria
  @foreign_key_type :id  # Usar :id (entero) para claves foráneas

  schema "permissions" do
    field :name, :string
    field :description, :string
    belongs_to :tenant, PruebaTecnica.Core.Tenants.Tenant  # Relación con Tenant
    many_to_many :roles, PruebaTecnica.Core.Authorization.Role, join_through: "role_permissions"  # Relación con Roles

    timestamps()  # Campos inserted_at y updated_at
  end

  @doc """
  Cambioset para crear o actualizar un permiso.
  """
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:name, :tenant_id, :description])
    |> validate_required([:name, :tenant_id])
    |> unique_constraint(:name, name: :permissions_name_tenant_id_index)  # El nombre debe ser único por tenant
  end
end
