defmodule PruebaTecnica.Core.Authorization.UserRole do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}  # Usar :id (entero) como clave primaria
  @foreign_key_type :id  # Usar :id (entero) para claves foráneas

  schema "user_roles" do
    belongs_to :user, PruebaTecnica.Core.Account.User
    belongs_to :role, PruebaTecnica.Core.Authorization.Role

    timestamps()  # Campos inserted_at y updated_at
  end

  @doc """
  Cambioset para crear o actualizar una relación usuario-rol.
  """
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:user_id, :role_id])
    |> validate_required([:user_id, :role_id])
    |> unique_constraint([:user_id, :role_id])  # Evitar duplicados
  end
end
