defmodule PruebaTecnicaWeb.TenantController do
  use PruebaTecnicaWeb, :controller
  alias PruebaTecnica.Core.Tenancy.UseCases.UseCasesTenants

  @doc """
  Crea un nuevo tenant.
  """
  def create(conn, %{"tenant" => tenant_params}) do
    case UseCasesTenants.create_tenant(tenant_params) do
      {:ok, _} ->
        conn
          |> put_status(:created)  # Código 201
          |> json(%{message: "Tenant successfully created"})

      {:error, changeset} ->
        conn
          |> put_status(:unprocessable_entity)  # Código 422
          |> json(%{errors: transform_changeset_errors(changeset)})
        _ ->
        conn
          |> put_status(:internal_server_error) #Codigo 500
    end
  end

  @doc """
  Lista todos los nombres de los tenants.
  """
  def index(conn, _params) do
    case UseCasesTenants.get_tenant_names() do
      {:ok, tenants} ->
        conn
          |> put_status(:ok)  # Código 200
          |> json(%{data: tenants})

      {:error, nil} ->
        conn
          |> put_status(:no_content)  # Código 204
      _ ->
        conn
          |> put_status(:internal_server_error) #Codigo 500
    end
  end

  @doc """
  Editas un tenant a partir del tenant_id
  """
  def update(conn, %{"id" => tenant_id, "tenant" => tenant_params}) do
    case UseCasesTenants.update_tenant(tenant_id, tenant_params) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Tenant successfully edited"})

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "Tenant not found"})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: transform_changeset_errors(changeset)})
    end
  end

  @doc """
  Elimina un tenant a partir del tenant_id
  """
  def delete(conn, %{"tenant_id" => tenant_id}) do
    case UseCasesTenants.delete_tenant(tenant_id) do
      {:ok, _} ->
        conn
          |> put_status(:ok)  # Código 200
          |> json(%{message: "Tenant successfully deleted"})

      {:error, :not_found} ->
        conn
          |> put_status(:not_found) #Codigo 404

      _ ->
        conn
          |> put_status(:internal_server_error) #Codigo 500
    end
  end

  # Función auxiliar para transformar errores de changeset a un formato amigable
  defp transform_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
