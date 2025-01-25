defmodule PruebaTecnicaWeb.AdminRolePlug do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    # Obtener los roles del usuario desde conn.assigns
    roles = conn.assigns[:roles]

    # Verificar si el usuario tiene el rol "Administrador"
    has_admin_role? =
      Enum.any?(roles, fn role ->
        role["name"] == "Administrador"
      end)

    if has_admin_role? do
      # Si el usuario tiene el rol "Administrador", permite continuar
      conn
    else
      # Si no tiene el rol "Administrador", devuelve un error 403 Forbidden
      conn
      |> send_forbidden_response("User does not have admin privileges")
      |> halt()
    end
  end

  defp send_forbidden_response(conn, message) do
    conn
    |> put_status(:forbidden)
    |> put_resp_content_type("application/json")
    |> send_resp(403, Jason.encode!(%{error: message}))
  end
end
