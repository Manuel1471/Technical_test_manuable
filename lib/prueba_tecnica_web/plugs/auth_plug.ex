defmodule PruebaTecnicaWeb.AuthPlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    token = get_token_from_header(conn)

    case PruebaTecnica.Infrastructure.JwtAuth.verify_token(token) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> halt()

      user ->
        assign(conn, :current_user, user)
    end
  end

  defp get_token_from_header(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> token
      _ -> nil
    end
  end
end
