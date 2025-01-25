defmodule PruebaTecnica.Core.Interfaces.Repositories.UserEntity do
  import Ecto.Query
  alias PruebaTecnica.Core.Infrastructure.Repo
  alias PruebaTecnica.Core.Account.User
  alias PruebaTecnica.Core.Authorization.UserRole
  alias PruebaTecnica.Core.Authorization.Role

  @doc """
  Crea un nuevo usuario.
  """
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Obtiene un usuario por su ID y tenant_id.
  """
  def get_user_by_id_and_tenant(user_id, tenant_id) do
    Repo.get_by(User, id: user_id, tenant_id: tenant_id)
  end

  @doc """
  Obtiene un usuario por su email y tenant_id.
  """
  def get_user_by_email_and_tenant(email, tenant_id) do
    query =
      from u in User,
        where: u.email == ^email and u.tenant_id == ^tenant_id,
        preload: [roles: ^from(r in Role, select: %{id: r.id, name: r.name})]

    Repo.one(query)
  end

  @doc """
  Lista todos los usuarios de un tenant.
  """
  def list_users_by_tenant(tenant_id) do
    User
    |> where(tenant_id: ^tenant_id)
    |> select([p], map(p, [:id, :name, :email, :tenant_id, :inserted_at, :updated_at]))
    |> Repo.all()
  end

  @doc """
  Actualiza un usuario existente.
  """
  def update_user(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Elimina un usuario existente.
  """
  def delete_user(user) do
    Repo.delete(user)
  end

  @doc """
  Asigna un rol a un usuario.
  """
  def add_role_to_user(user_id, role_id) do
    %UserRole{}
    |> UserRole.changeset(%{user_id: user_id, role_id: role_id})
    |> Repo.insert()
  end

  @doc """
  Asigna roles adicionales a un usuario.
  """
  def add_roles_to_user(user_id, role_ids) do
    # Obtener los roles actuales del usuario
    existing_role_ids =
      from(ur in UserRole, where: ur.user_id == ^user_id, select: ur.role_id)
      |> Repo.all()

    # Filtrar los roles que el usuario ya tiene
    new_role_ids = role_ids -- existing_role_ids

    if new_role_ids != [] do
      IO.inspect(new_role_ids)
      user_id = String.to_integer(user_id)

      now = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

      # Preparamos los datos para la inserción masiva
      records =
        Enum.map(new_role_ids, fn role_id ->
          %{
            user_id: user_id,
            role_id: role_id,
            inserted_at: now,
            updated_at: now
          }
        end)

      # Insertamos solo los roles nuevos
      Repo.insert_all(UserRole, records)
    end

    :ok
  end

  # Función auxiliar para obtener los roles del usuario
  def get_user_roles(user) do
    user
    |> Ecto.assoc(:roles)  # Cargar los roles asociados al usuario
    |> Repo.all()  # Obtener la lista de roles desde la base de datos
    |> Enum.map(& &1.name)  # Extraer los nombres de los roles
  end
end
