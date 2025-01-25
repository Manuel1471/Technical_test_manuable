defmodule PruebaTecnicaWeb.AuthPlug do
  @moduledoc """
  Plug para autenticar solicitudes usando tokens JWT.
  """

  import Plug.Conn
  alias PruebaTecnica.Core.Infrastructure.JwtAuth

  def init(default), do: default

  def call(conn, _default) do
    conn
    |> get_token_from_request()
    |> verify_and_assign_user(conn)
  end

  # Extrae el token del encabezado Authorization
  defp get_token_from_request(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> token
      _ -> nil
    end
  end

  # Verifica el token y asigna el usuario actual si es válido
  defp verify_and_assign_user(nil, conn) do
    conn
    |> send_unauthorized_response("An authentication token is required.")
    |> halt()
  end

  defp verify_and_assign_user(token, conn) do
    case JwtAuth.verify_token(token) do
      {:ok, claims} ->
        conn
        |> assign(:current_user, claims)  # Almacena los claims en conn.assigns
        |> assign(:user_id, claims["user_id"])  # Almacena el user_id
        |> assign(:tenant_id, claims["tenant_id"])  # Almacena el tenant_id
        |> assign(:roles, claims["roles"])  # Almacena el rol

      {:error, reason} ->
        conn
        |> send_unauthorized_response("Invalid token: #{reason}")
        |> halt()
    end
  end

  # Envía una respuesta de error 401 (Unauthorized)
  defp send_unauthorized_response(conn, message) do
    conn
    |> put_status(:unauthorized)
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{error: message}))
  end
end
