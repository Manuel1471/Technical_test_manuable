defmodule PruebaTecnicaWeb.Router do
  use PruebaTecnicaWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug PruebaTecnicaWeb.AuthPlug
  end

  pipeline :admin do
    plug PruebaTecnicaWeb.AdminRolePlug
  end

  scope "/api", PruebaTecnicaWeb do
    pipe_through [:api]

    post "/tenants/:tenant_id/authenticate", UserController, :authenticate
  end

  scope "/api", PruebaTecnicaWeb do
    pipe_through [:api, :auth, :admin]

    post "/role/:tenant_id", RoleController, :create
    patch "/role/:tenant_id/:role_id", RoleController, :update
    delete "/role/:tenant_id/:role_id", RoleController, :delete

    post "/tenants/:tenant_id/users", UserController, :create
    get "/tenants/:tenant_id/users", UserController, :list_users_by_tenant
    put "/tenants/:tenant_id/users/:id", UserController, :update
    delete "/tenants/:tenant_id/users/:id", UserController, :delete

    post "/role/:tenant_id/permissions", RoleController, :add_permission_to_role
    delete "/role/:tenant_id/:role_id/permissions/:permission_id", RoleController, :remove_permission_from_role
    post "/role/:tenant_id/permissions/bulk", RoleController, :add_permissions_to_role

    post "/tenants/:tenant_id/users/:user_id/roles", UserController, :add_roles_to_user

  end

  scope "/api", PruebaTecnicaWeb do
    pipe_through [:api, :auth]

    get "/tenants", TenantController, :index
    post "/tenants", TenantController, :create
    delete "/tenants/:tenant_id", TenantController, :delete
    patch "/tenants/:id", TenantController, :update

    post "/permissions/:tenant_id", PermissionController, :create
    get "/permissions/:tenant_id", PermissionController, :index
    delete "/permissions/:tenant_id/:permission_id", PermissionController, :delete
    patch "/permissions/:tenant_id/:permission_id", PermissionController, :update

    get "/role/:tenant_id", RoleController, :list_roles_by_tenant

    get "/role/:tenant_id/permissions", RoleController, :list_permissions_by_role
  end
end
