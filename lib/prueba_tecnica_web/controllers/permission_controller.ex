defmodule PruebaTecnicaWeb.PermissionController do
  use PruebaTecnicaWeb, :controller
  alias PruebaTecnica.Core.Authorization.UseCases.UseCasesPermissions

  # Crear un nuevo permiso
  def create(conn, %{"tenant_id" => tenant_id, "permission" => permission_params}) do
    # Combina el tenant_id con los parámetros del permiso
    permission_params_with_tenant = Map.put(permission_params, "tenant_id", tenant_id)

    # Llama al caso de uso para crear el permiso
    case UseCasesPermissions.create_permission(tenant_id, permission_params_with_tenant) do
      {:ok, _} ->
        conn
        # Código 201
        |> put_status(:created)
        |> json(%{message: "Permission successfully created"})

      {:error, :tenant_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: "Tenant not found"})

      {:error, error} ->
        conn
        # Código 422
        |> put_status(:unprocessable_entity)
        |> json(%{errors: transform_changeset_errors(error)})

      _ ->
        conn
        # Código 500
        |> put_status(:internal_server_error)
    end
  end

  def index(conn, %{"tenant_id" => tenant_id}) do
    case UseCasesPermissions.get_permissions_by_tenant(tenant_id) do
      {:ok, permissions} ->
        conn
        # Código 200
        |> put_status(:ok)
        |> json(%{data: permissions})

      {:error, :tenant_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: "Tenant not found"})

      _ ->
        conn
        # Codigo 500
        |> put_status(:internal_server_error)
    end
  end

  def update(conn, %{
        "tenant_id" => tenant_id,
        "permission_id" => permission_id,
        "permission" => permission_params
      }) do
    permission_params_with_tenant = Map.put(permission_params, "tenant_id", tenant_id)

    case UseCasesPermissions.update_permission(
           tenant_id,
           permission_id,
           permission_params_with_tenant
         ) do
      {:ok, _permission} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Permission updated successfully"})

      {:error, :tenant_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: "Tenant not found"})

      {:error, :permission_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: "Permission not found"})

      _ ->
        conn
        # Codigo 500
        |> put_status(:internal_server_error)
    end
  end

  @doc """
  Elimina un permiso existente.
  """
  def delete(conn, %{"tenant_id" => tenant_id, "permission_id" => permission_id}) do
    case UseCasesPermissions.delete_permission(tenant_id, permission_id) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> send_resp(204, "")

      {:error, :tenant_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Tenant not found"})

      {:error, :permission_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Permission not found"})

      _ ->
        conn
        # Codigo 500
        |> put_status(:internal_server_error)
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
