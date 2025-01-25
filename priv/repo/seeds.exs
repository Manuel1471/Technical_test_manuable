
alias PruebaTecnica.Core.Infrastructure.Repo
alias PruebaTecnica.Core.Tenants.Tenant
alias PruebaTecnica.Core.Authorization.Role
alias PruebaTecnica.Core.Account.User
alias PruebaTecnica.Core.Authorization.Permission
alias PruebaTecnica.Core.Authorization.UserRole
alias PruebaTecnica.Core.Authorization.RolePermission

# Insertar tenants de ejemplo
tenant1 = Repo.insert!(%Tenant{
  name: "Tenant 1",
}) |> IO.inspect()

tenant2 = Repo.insert!(%Tenant{
  name: "Tenant 2",
})

# Insertar roles para Tenant 1
admin_role = Repo.insert!(%Role{
  name: "Administrador",
  description: "Rol con permisos completos",
  tenant_id: tenant1.id
})

user_role = Repo.insert!(%Role{
  name: "Usuario",
  description: "Rol sin permisos de administración",
  tenant_id: tenant1.id
})

# Insertar permisos para Tenant 1
manage_users_permission = Repo.insert!(%Permission{
  name: "manage_users",
  description: "Permiso para gestionar usuarios",
  tenant_id: tenant1.id
})

manage_roles_permission = Repo.insert!(%Permission{
  name: "manage_roles",
  description: "Permiso para gestionar roles",
  tenant_id: tenant1.id
})

# Asignar permisos al rol "Administrador"
Repo.insert!(%RolePermission{
  role_id: admin_role.id,
  permission_id: manage_users_permission.id
})

Repo.insert!(%RolePermission{
  role_id: admin_role.id,
  permission_id: manage_roles_permission.id
})

# El rol "Usuario" no tiene permisos asignados

# Insertar usuarios para Tenant 1
admin_user = Repo.insert!(%User{
  name: "Admin User",
  email: "admin@example.com",
  password_hash: Pbkdf2.hash_pwd_salt("password123"), # Usar Pbkdf2 para hashear la contraseña
  tenant_id: tenant1.id
})

regular_user = Repo.insert!(%User{
  name: "Regular User",
  email: "user@example.com",
  password_hash: Pbkdf2.hash_pwd_salt("password123"),
  tenant_id: tenant1.id
})

# Asignar roles a los usuarios de Tenant 1
Repo.insert!(%UserRole{
  user_id: admin_user.id,
  role_id: admin_role.id
})

Repo.insert!(%UserRole{
  user_id: regular_user.id,
  role_id: user_role.id
})

# Insertar un usuario para Tenant 2 (sin roles ni permisos especiales)
tenant2_user = Repo.insert!(%User{
  name: "Tenant 2 User",
  email: "tenant2@example.com",
  password_hash: Pbkdf2.hash_pwd_salt("password123"),
  tenant_id: tenant2.id
})
