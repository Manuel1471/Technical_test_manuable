defmodule PruebaTecnicaWeb.PageController do
  use PruebaTecnicaWeb, :controller

  @spec home(any(), any()) :: <<_::32>>
  def home(conn, _params) do
    text(conn, "Hola")
  end
end
