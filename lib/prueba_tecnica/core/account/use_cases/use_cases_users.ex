defmodule PruebaTecnica.Core.Account.UseCases.UseCasesUsers do
  alias PruebaTecnica.Core.Interfaces.Repositories.UserEntity
  alias PruebaTecnica.Core.Interfaces.Repositories.TenantEntity
  alias PruebaTecnica.Core.Infrastructure.JwtAuth
  alias PruebaTecnica.Core.Interfaces.Repositories.RoleEntity
  alias PruebaTecnica.Core.Account.User

  @doc """
  Crea un nuevo usuario asignado a un tenant y al menos un rol.
  """
  def create_user(tenant_id, user_attrs, role_ids) do
    # Verificar que el tenant exista
    case TenantEntity.get_tenant_by_id(tenant_id) do
      nil ->
        {:error, :tenant_not_found}

      _tenant ->
        # Crear el usuario
        case UserEntity.create_user(Map.put(user_attrs, "tenant_id", tenant_id)) do
          {:ok, user} ->
            # Asignar roles al usuario
            Enum.each(role_ids, fn role_id ->
              UserEntity.add_role_to_user(user.id, role_id)
            end)
            {:ok, user}

          {:error, changeset} ->
            {:error, changeset}
        end
    end
  end

  @doc """
  Lista todos los usuarios de un tenant.
  """
  def list_users_by_tenant(tenant_id) do
    case TenantEntity.get_tenant_by_id(tenant_id) do
      nil ->
        {:error, :tenant_not_found}

      _tenant ->
        {:ok, UserEntity.list_users_by_tenant(tenant_id)}
    end
  end

  @doc """
  Actualiza un usuario existente.
  """
  def update_user(tenant_id, user_id, user_attrs) do
    # Verificar que el usuario exista y pertenezca al tenant
    case UserEntity.get_user_by_id_and_tenant(user_id, tenant_id) do
      nil ->
        {:error, :user_not_found}

      user ->
        UserEntity.update_user(user, user_attrs)
    end
  end

  @doc """
  Elimina un usuario existente.
  """
  def delete_user(tenant_id, user_id) do
    # Verificar que el usuario exista y pertenezca al tenant
    case UserEntity.get_user_by_id_and_tenant(user_id, tenant_id) do
      nil ->
        {:error, :user_not_found}

      user ->
        UserEntity.delete_user(user)
    end
  end


  def authenticate_user(email, password, tenant_id) do
    # Verificar que el tenant exista
    case TenantEntity.get_tenant_by_id(tenant_id) do
      nil ->
        {:error, :tenant_not_found}

      _tenant ->
        # Buscar al usuario por email y tenant_id
        case UserEntity.get_user_by_email_and_tenant(email, tenant_id) do
          nil ->
            {:error, :user_not_found}

          %User{password_hash: password_hash} = user ->
            # Verificar la contraseña usando Pbkdf2
            if Pbkdf2.verify_pass(password, password_hash) do

              # Generar un token JWT con los roles del usuario
              token = JwtAuth.generate_token(user.id, user.tenant_id, user.roles)
              {:ok, token}
            else
              {:error, :invalid_credentials}
            end
        end
    end
  end

  @doc """
  Asigna roles adicionales a un usuario.
  """
  def add_roles_to_user(tenant_id, user_id, role_ids) do
    # Verificar que el tenant exista
    case TenantEntity.get_tenant_by_id(tenant_id) do
      nil ->
        {:error, :tenant_not_found}

      _tenant ->
        # Verificar que el usuario exista y pertenezca al tenant
        case UserEntity.get_user_by_id_and_tenant(user_id, tenant_id) do
          nil ->
            {:error, :user_not_found}

          _user ->
            # Verificar que todos los roles existan
            case RoleEntity.check_roles_exist(role_ids) do
              [] ->
                # Todos los roles existen, asignarlos al usuario
                UserEntity.add_roles_to_user(user_id, role_ids)
                {:ok, :roles_added}

              missing_role_ids ->
                # Algunos roles no existen, devolver un error con los IDs faltantes
                {:error, {:roles_not_found, missing_role_ids}}
            end
        end
    end
  end
end
