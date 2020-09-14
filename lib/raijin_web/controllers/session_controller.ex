defmodule RaijinWeb.SessionController do
  use RaijinWeb, :controller
  alias Raijin.Users

  def login(conn, %{"username" => username, "password" => password}) do
    with {:ok, user} <- Users.verify_user(username, password) do
      conn
      |> put_session(:user_id, user.id)
      |> put_view(RaijinWeb.UserView)
      |> render("show.json", user: user)
    end
  end

  def logout(%{assigns: %{current_user: _current_user}} = conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_status(200)
  end
end
