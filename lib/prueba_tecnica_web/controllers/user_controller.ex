defmodule PruebaTecnicaWeb.UserController do
  use PruebaTecnicaWeb, :controller
  alias PruebaTecnica.Core.Account.UseCases.UseCasesUsers

  @doc """
  Crea un nuevo usuario.
  """
  def create(conn, %{"tenant_id" => tenant_id} = params) do
    # Extrae los parámetros directamente del cuerpo de la solicitud
    user_params = %{
      "name" => params["name"],
      "email" => params["email"],
      "password_hash" => Pbkdf2.hash_pwd_salt(params["password"]),
      "role_ids" => params["role_ids"] || []  # Asegúrate de manejar el caso en que role_ids no esté presente
    }

    case UseCasesUsers.create_user(tenant_id, user_params, user_params["role_ids"]) do
      {:ok, _} ->
        conn
        |> put_status(:created)
        |> json(%{message: "User created successfully"})

      {:error, :tenant_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Tenant not found"})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: transform_changeset_errors(changeset)})
    end
  end

  @doc """
  Lista todos los usuarios de un tenant.
  """
  def list_users_by_tenant(conn, %{"tenant_id" => tenant_id}) do
    case UseCasesUsers.list_users_by_tenant(tenant_id) do
      {:ok, users} ->
        conn
        |> put_status(:ok)
        |> json(%{users: users})

      {:error, :tenant_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Tenant not found"})
    end
  end

  @doc """
  Actualiza un usuario existente.
  """
  def update(conn, %{"tenant_id" => tenant_id, "id" => user_id, "user" => user_attrs}) do
    case UseCasesUsers.update_user(tenant_id, user_id, user_attrs) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "User updated successfully"})

      {:error, :user_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: transform_changeset_errors(changeset)})
    end
  end

  @doc """
  Elimina un usuario existente.
  """
  def delete(conn, %{"tenant_id" => tenant_id, "id" => user_id}) do
    case UseCasesUsers.delete_user(tenant_id, user_id) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "User deleted successfully"})

      {:error, :user_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})
    end
  end

  @doc """
  Asigna roles adicionales a un usuario.
  """
  def add_roles_to_user(conn, %{"tenant_id" => tenant_id, "user_id" => user_id, "role_ids" => role_ids}) do
    case UseCasesUsers.add_roles_to_user(tenant_id, user_id, role_ids) do
      {:ok, :roles_added} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Roles added to user successfully"})

      {:error, :tenant_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Tenant not found"})

      {:error, :user_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      {:error, {:roles_not_found, missing_role_ids}} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Some roles not found", missing_role_ids: missing_role_ids})

      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Internal server error", details: inspect(reason)})
    end
  end

  @doc """
  Autentica a un usuario y devuelve un token JWT si las credenciales son válidas.
  """
  def authenticate(conn, %{"tenant_id" => tenant_id} = params) do
    # Extraer email y password del cuerpo de la solicitud
    email = Map.get(params, "email")
    password = Map.get(params, "password")

    # Convertir tenant_id a entero
    tenant_id = String.to_integer(tenant_id)

    # Verificar que email y password estén presentes
    if is_nil(email) or is_nil(password) do
      conn
      |> put_status(:bad_request)
      |> json(%{error: "Email and password are required"})
    else
      # Llamar a la lógica de autenticación
      case UseCasesUsers.authenticate_user(email, password, tenant_id) do
        {:ok, token} ->
          # Si la autenticación es exitosa, devolver el token
          conn
          |> put_status(:ok)
          |> json(%{token: token})

        {:error, :tenant_not_found} ->
          # Si el tenant no existe, devolver un error 404
          conn
          |> put_status(:not_found)
          |> json(%{error: "Tenant not found"})

        {:error, :user_not_found} ->
          # Si el usuario no existe, devolver un error 404
          conn
          |> put_status(:not_found)
          |> json(%{error: "User not found"})

        {:error, :invalid_credentials} ->
          # Si las credenciales son inválidas, devolver un error 401
          conn
          |> put_status(:unauthorized)
          |> json(%{error: "Invalid credentials"})
      end
    end
  end


  # Función auxiliar para transformar errores del changeset
  defp transform_changeset_errors(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {message, _opts}} ->
      {field, message}
    end)
    |> Enum.into(%{})
  end
end
