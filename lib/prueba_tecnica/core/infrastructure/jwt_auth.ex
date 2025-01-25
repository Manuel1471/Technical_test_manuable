defmodule PruebaTecnica.Core.Infrastructure.JwtAuth do
  @moduledoc """
  Módulo para manejar la generación y verificación de tokens JWT usando Joken.
  """

  alias Joken.Signer

  # Obtén la configuración desde config.ex
  @default_signer Keyword.fetch!(Application.compile_env(:prueba_tecnica, :joken), :default_signer)

  # Crea el signer directamente
  @signer Signer.create("HS256", @default_signer)

  @doc """
  Genera un token JWT para un usuario.
  """
  def generate_token(user_id, tenant_id, roles) do
    # Configura los claims del token
    claims = %{
      "user_id" => user_id,
      "tenant_id" => tenant_id,
      "roles" => roles,  # Incluye el rol en el token
      "exp" => System.system_time(:second) + 7200  # Expira en 2 horas
    }

    # Genera el token firmado
    {:ok, token, _claims} = Joken.generate_and_sign(%{}, claims, @signer)
    token
  end

  @doc """
  Verifica un token JWT y devuelve los claims si es válido.
  """
  def verify_token(token) do
    # Verifica el token y decodifica los claims
    case Joken.verify_and_validate(%{}, token, @signer) do
      {:ok, claims} ->
        {:ok, claims}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
