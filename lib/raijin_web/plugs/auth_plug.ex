defmodule RaijinWeb.Plugs.AuthPlug do
  import Plug.Conn
  alias Raijin.Users

  def init(_opts) do
    :ok
  end

  def call(conn, _opts) do
    fetch_session(conn)

    case get_session(conn, :user_id) do
      nil -> assign(conn, :current_user, nil)
      user_id -> get_and_assign_user(conn, user_id)
    end
  end

  defp get_and_assign_user(conn, user_id) do
    case Users.get_user!(user_id) do
      nil -> assign(conn, :current_user, nil)
      user -> assign(conn, :current_user, user)
    end
  end
end
