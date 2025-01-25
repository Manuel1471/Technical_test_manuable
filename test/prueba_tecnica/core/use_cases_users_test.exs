
#defmodule PruebaTecnica.Core.Account.UseCases.UseCasesUsersTest do
#  use ExUnit.Case, async: true
#  alias PruebaTecnica.Core.Account.UseCases.UseCasesUsers
#  alias PruebaTecnica.Core.Tenants.Tenant
#  alias PruebaTecnica.Core.Authorization.Role
#  alias PruebaTecnica.Core.Account.User
#  alias PruebaTecnica.Core.Infrastructure.Repo
#
#  setup do
#    # Limpiar la base de datos antes de cada test
#    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
#
#    # Insertar un tenant y roles de prueba
#    tenant = Repo.insert!(%Tenant{name: "Test Tenant"})
#    admin_role = Repo.insert!(%Role{name: "Administrador", tenant_id: tenant.id})
#    user_role = Repo.insert!(%Role{name: "Usuario", tenant_id: tenant.id})
#
#    {:ok, tenant: tenant, admin_role: admin_role, user_role: user_role}
#  end
#
#  test "create_user/3 crea un usuario con roles válidos", %{tenant: tenant, admin_role: admin_role} do
#    # Datos válidos
#    user_attrs = %{name: "New User", email: "user@example.com", password: "password123"}
#    role_ids = [admin_role.id]
#
#    # Probar la función
#    {:ok, user} = UseCasesUsers.create_user(tenant.id, user_attrs, role_ids)
#    assert user.name == "New User"
#  end
#
#  test "create_user/3 devuelve un error si el tenant no existe" do
#    # Datos válidos
#    user_attrs = %{name: "New User", email: "user@example.com", password: "password123"}
#    role_ids = [1]
#
#    # Probar la función con un tenant inexistente
#    assert UseCasesUsers.create_user(999, user_attrs, role_ids) == {:error, :tenant_not_found}
#  end
#
#  test "authenticate_user/3 autentica un usuario con credenciales válidas", %{tenant: tenant} do
#    # Insertar un usuario de prueba
#    user = Repo.insert!(%User{
#      name: "Test User",
#      email: "user@example.com",
#      password_hash: Pbkdf2.hash_pwd_salt("password123"),
#      tenant_id: tenant.id
#    })
#
#    # Probar la función
#    {:ok, token} = UseCasesUsers.authenticate_user("user@example.com", "password123", tenant.id)
#    assert is_binary(token)
#  end
#
#  test "authenticate_user/3 devuelve un error con credenciales inválidas", %{tenant: tenant} do
#    # Insertar un usuario de prueba
#    Repo.insert!(%User{
#      name: "Test User",
#      email: "user@example.com",
#      password_hash: Pbkdf2.hash_pwd_salt("password123"),
#      tenant_id: tenant.id
#    })
#
#    # Probar la función con contraseña incorrecta
#    assert UseCasesUsers.authenticate_user("user@example.com", "wrong_password", tenant.id) == {:error, :invalid_credentials}
#  end
#
#  test "add_roles_to_user/3 asigna roles adicionales a un usuario", %{tenant: tenant, admin_role: admin_role, user_role: user_role} do
#    # Insertar un usuario de prueba
#    user = Repo.insert!(%User{
#      name: "Test User",
#      email: "user@example.com",
#      password_hash: Pbkdf2.hash_pwd_salt("password123"),
#      tenant_id: tenant.id
#    })
#
#    # Probar la función
#    assert UseCasesUsers.add_roles_to_user(tenant.id, user.id, [admin_role.id, user_role.id]) == {:ok, :roles_added}
#  end
#
#  test "add_roles_to_user/3 devuelve un error si algún rol no existe", %{tenant: tenant} do
#    # Insertar un usuario de prueba
#    user = Repo.insert!(%User{
#      name: "Test User",
#      email: "user@example.com",
#      password_hash: Pbkdf2.hash_pwd_salt("password123"),
#      tenant_id: tenant.id
#    })
#
#    # Probar la función con roles inexistentes
#    assert UseCasesUsers.add_roles_to_user(tenant.id, user.id, [999, 1000]) == {:error, {:roles_not_found, [999, 1000]}}
#  end
#end
#
