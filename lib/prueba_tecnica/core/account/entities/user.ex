defmodule PruebaTecnica.Core.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}  # Usar :id (entero) como clave primaria
  @foreign_key_type :id  # Usar :id (entero) para claves foráneas

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    belongs_to :tenant, PruebaTecnica.Core.Tenancy.Tenant  # Relación con Tenant
    many_to_many :roles, PruebaTecnica.Core.Authorization.Role, join_through: "user_roles"  # Relación con Roles

    timestamps()  # Campos inserted_at y updated_at
  end

  @doc """
  Cambioset para crear o actualizar un usuario.
  """
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password_hash, :tenant_id])
    |> validate_required([:name, :email, :password_hash, :tenant_id])
    |> unique_constraint(:email, name: :users_email_tenant_id_index)  # El email debe ser único por tenant
  end
end
