defmodule PruebaTecnica.Core.UseCasesTenantsTest do
  use ExUnit.Case, async: true
  alias PruebaTecnica.Core.Tenants.UseCases.UseCasesTenants
  alias PruebaTecnica.Core.Tenants.Tenant
  alias PruebaTecnica.Core.Infrastructure.Repo

  setup do
    # Limpiar la base de datos antes de cada test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "get_tenants/0 devuelve una lista de tenants con id y name" do
    # Insertar tenants de prueba
    tenant1 = Repo.insert!(%Tenant{name: "Tenant 1"})
    tenant2 = Repo.insert!(%Tenant{name: "Tenant 2"})

    # Probar la función
    {:ok, tenants} = UseCasesTenants.get_tenants()

    # Verificar que la lista contiene los tenants esperados
    assert Enum.sort_by(tenants, & &1.id) == [
      %{id: tenant1.id, name: "Tenant 1"},
      %{id: tenant2.id, name: "Tenant 2"}
    ]
  end

  test "get_tenants devuelve un error si no hay tenants" do
    # Probar la función sin datos
    assert UseCasesTenants.get_tenants() == {:error, nil}
  end

  test "get_tenant_by_id/1 devuelve un tenant existente" do
    # Insertar un tenant de prueba
    tenant = Repo.insert!(%Tenant{name: "Test Tenant"})

    # Probar la función
    {:ok, found_tenant} = UseCasesTenants.get_tenant_by_id(tenant.id)
    assert found_tenant.id == tenant.id
  end

  test "get_tenant_by_id/1 devuelve un error si el tenant no existe" do
    # Probar la función con un ID inexistente
    assert UseCasesTenants.get_tenant_by_id(999) == {:error, :not_found}
  end

  test "create_tenant/1 crea un tenant con datos válidos" do
    # Datos válidos
    attrs = %{name: "New Tenant", description: "Descripción del tenant"}

    # Probar la función
    {:ok, tenant} = UseCasesTenants.create_tenant(attrs)
    assert tenant.name == "New Tenant"
  end

  test "create_tenant/1 devuelve un error con datos inválidos" do
    # Datos inválidos (nombre faltante)
    attrs = %{description: "Descripción sin nombre"}

    # Probar la función
    {:error, changeset} = UseCasesTenants.create_tenant(attrs)
    assert "can't be blank" in errors_on(changeset).name
  end

  test "update_tenant/2 actualiza un tenant existente" do
    # Insertar un tenant de prueba
    tenant = Repo.insert!(%Tenant{name: "Old Name"})

    # Probar la función
    {:ok, updated_tenant} = UseCasesTenants.update_tenant(tenant.id, %{name: "New Name"})
    assert updated_tenant.name == "New Name"
  end

  test "update_tenant/2 devuelve un error si el tenant no existe" do
    # Probar la función con un ID inexistente
    assert UseCasesTenants.update_tenant(999, %{name: "New Name"}) == {:error, :not_found}
  end

  test "delete_tenant/1 elimina un tenant existente" do
    # Insertar un tenant de prueba
    tenant = Repo.insert!(%Tenant{name: "Test Tenant"})

    # Probar la función
    assert {:ok, deleted_tenant} = UseCasesTenants.delete_tenant(tenant.id)

    # Verificar que los campos principales coincidan
    assert deleted_tenant.id == tenant.id
    assert deleted_tenant.name == tenant.name
    assert deleted_tenant.inserted_at == tenant.inserted_at
    assert deleted_tenant.updated_at == tenant.updated_at

    # Ignorar el estado de las asociaciones
    assert deleted_tenant.__meta__.state == :deleted
  end

  test "delete_tenant/1 devuelve un error si el tenant no existe" do
    # Probar la función con un ID inexistente
    assert UseCasesTenants.delete_tenant(999) == {:error, :not_found}
  end

  # Función para obtener errores de un changeset
  defp errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
