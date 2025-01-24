defmodule PruebaTecnica.Core.Authorization.Role do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}  # Usar :id (entero) como clave primaria
  @foreign_key_type :id  # Usar :id (entero) para claves foráneas

  schema "roles" do
    field :name, :string
    belongs_to :tenant, PruebaTecnica.Core.Tenancy.Tenant  # Relación con Tenant
    many_to_many :users, PruebaTecnica.Core.Accounts.User, join_through: "user_roles"  # Relación con Users
    many_to_many :permissions, PruebaTecnica.Core.Authorization.Permission, join_through: "role_permissions"  # Relación con Permissions

    timestamps()  # Campos inserted_at y updated_at
  end

  @doc """
  Cambioset para crear o actualizar un rol.
  """
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :tenant_id])
    |> validate_required([:name, :tenant_id])
    |> unique_constraint(:name, name: :roles_name_tenant_id_index)  # El nombre debe ser único por tenant
  end
end
