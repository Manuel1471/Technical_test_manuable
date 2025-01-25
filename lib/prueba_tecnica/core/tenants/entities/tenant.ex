defmodule PruebaTecnica.Core.Tenants.Tenant do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}  # Usar :id (entero) como clave primaria
  @foreign_key_type :id  # Usar :id (entero) para claves foráneas

  schema "tenants" do
    field :name, :string  # Nombre del inquilino

    # Relaciones
    has_many :users, PruebaTecnica.Core.Account.User
    has_many :roles, PruebaTecnica.Core.Authorization.Role
    has_many :permissions, PruebaTecnica.Core.Authorization.Permission

    timestamps()  # Campos inserted_at y updated_at
  end

  @doc """
  Cambioset para crear o actualizar un inquilino.
  """
  def changeset(tenant, attrs) do
    tenant
    |> cast(attrs, [:name])
    |> validate_required([:name])  # El nombre es obligatorio
    |> unique_constraint(:name)    # El nombre debe ser único
  end
end
