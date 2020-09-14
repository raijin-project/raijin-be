defmodule RaijinWeb.UserController do
  use RaijinWeb, :controller

  alias Raijin.Users
  alias Raijin.Users.User

  action_fallback RaijinWeb.FallbackController

  def index(conn, _params) do
    user = conn.assigns.current_user

    with :ok <- Bodyguard.permit(Users, :list_users, user),
         users <- Users.list_users() do
      render(conn, "index.json", users: users)
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    updating_user = conn.assigns.current_user
    user = Users.get_user!(id)

    with :ok <- Bodyguard.permit(Users, :update_user, updating_user, user),
         {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    deleting_user = conn.assigns.current_user
    user = Users.get_user!(id)

    with :ok <- Bodyguard.permit(Users, :update_user, deleting_user, user),
         {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
