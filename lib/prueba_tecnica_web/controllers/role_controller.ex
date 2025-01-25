defmodule PruebaTecnicaWeb.RoleController do
  use PruebaTecnicaWeb, :controller
  alias PruebaTecnica.Core.Authorization.UseCases.UseCasesRoles

  @doc """
  Crea un nuevo rol para un tenant.
  """
  def create(conn, %{"tenant_id" => tenant_id, "role" => role_params}) do
    case UseCasesRoles.create_role(tenant_id, role_params) do
      {:ok, _} ->
        conn
        |> put_status(:created)
        |> json(%{message: "Role created successfully"})

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
  Actualiza un rol existente para un tenant.
  """
  def update(conn, %{"tenant_id" => tenant_id, "role_id" => role_id, "role" => role_params}) do
    case UseCasesRoles.update_role(tenant_id, role_id, role_params) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Role updated successfully"})

      {:error, :tenant_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Tenant not found"})

      {:error, :role_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Role not found"})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: transform_changeset_errors(changeset)})
    end
  end

  @doc """
  Elimina un rol existente para un tenant.
  """
  def delete(conn, %{"tenant_id" => tenant_id, "role_id" => role_id}) do
    case UseCasesRoles.delete_role(tenant_id, role_id) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Role successfully deleted"})

      {:error, :tenant_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Tenant not found"})

      {:error, :role_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Role not found"})

      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Internal server error", details: inspect(reason)})
    end
  end

  @doc """
  Lista todos los roles de un tenant.
  """
  def list_roles_by_tenant(conn, %{"tenant_id" => tenant_id}) do
    case UseCasesRoles.list_roles_by_tenant(tenant_id) do
      {:ok, roles} ->
        conn
        |> put_status(:ok)
        |> json(%{roles: roles})

      {:error, :tenant_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Tenant not found"})
    end
  end

  @doc """
  Asocia un permiso a un rol.
  """
  def add_permission_to_role(conn, %{"tenant_id" => tenant_id, "role_id" => role_id, "permission_id" => permission_id}) do
    case UseCasesRoles.add_permission_to_role(tenant_id, role_id, permission_id) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Permission added to role successfully"})

      {:error, :tenant_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Tenant not found"})

      {:error, :role_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Role not found"})

      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Internal server error", details: inspect(reason)})
    end
  end

  @doc """
  Desasocia un permiso de un rol.
  """
  def remove_permission_from_role(conn, %{"tenant_id" => tenant_id, "role_id" => role_id, "permission_id" => permission_id}) do
    case UseCasesRoles.remove_permission_from_role(tenant_id, role_id, permission_id) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Permission deleted to role successfully"})

      {:error, :tenant_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Tenant not found"})

      {:error, :role_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Role not found"})

      {:error, :permission_not_associated} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Permission_not_associated"})

      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Internal server error", details: inspect(reason)})
    end
  end

  @doc """
  Lista los permisos asociados a un rol.
  """
  def list_permissions_by_role(conn, %{"tenant_id" => tenant_id, "role_id" => role_id}) do
    case UseCasesRoles.list_permissions_by_role(tenant_id, role_id) do
      {:ok, permissions} ->
        conn
        |> put_status(:ok)
        |> json(%{permissions: permissions})

      {:error, :tenant_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Tenant not found"})

      {:error, :role_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Role not found"})
    end
  end

  @doc """
  Asocia múltiples permisos a un rol.
  """
  def add_permissions_to_role(conn, %{"tenant_id" => tenant_id, "role_id" => role_id, "permission_ids" => permission_ids}) do
    case UseCasesRoles.add_permissions_to_role(tenant_id, role_id, permission_ids) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Permissions added to role successfully"})

      {:error, :tenant_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Tenant not found"})

      {:error, :role_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Role not found"})

      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Internal server error", details: inspect(reason)})
    end
  end

  # Función auxiliar para transformar errores de changeset a un formato amigable
  defp transform_changeset_errors(%Ecto.Changeset{} = changeset) do
    changeset.errors
    |> Enum.map(fn {field, {message, _opts}} ->
      {field, message}
    end)
    |> Enum.into(%{})
  end

  # Función para otros errores
  defp transform_changeset_errors(error) do
    error
  end
end
