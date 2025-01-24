defmodule PruebaTecnica.Infrastructure.JwtAuth do
  use Guardian, otp_app: :prueba_tecnica

  alias PruebaTecnica.Core.Accounts.User
  alias PruebaTecnica.Core.Infrastructure.Repo

  @doc """
  Genera un token JWT para un usuario.
  """
  def generate_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    token
  end

  @doc """
  Verifica un token JWT y devuelve el usuario asociado.
  """
  def verify_token(token) do
    case decode_and_verify(token) do
      {:ok, claims} ->
        user_id = claims["sub"]  # El ID del usuario está en el claim "sub"
        Repo.get(User, user_id)

      {:error, _reason} ->
        nil
    end
  end

  @doc """
  Callback para obtener el subject (ID del usuario) desde el recurso (usuario).
  """
  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  @doc """
  Callback para obtener el recurso (usuario) desde el subject (ID del usuario).
  """
  def resource_from_claims(claims) do
    user_id = claims["sub"]
    Repo.get(User, user_id)
  end
end
