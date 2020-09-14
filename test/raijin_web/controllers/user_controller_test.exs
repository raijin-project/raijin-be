defmodule RaijinWeb.UserControllerTest do
  use RaijinWeb.ConnCase

  alias Raijin.Users
  alias Raijin.Users.User

  @create_attrs %{
    username: "kawen",
    email: "kawen@imkawen",
    password: "imkawen",
    admin: true
  }
  @update_attrs %{
    email: "notkawen@imkawen",
    password: "notkawen"
  }
  @invalid_attrs %{
    username: "ka",
    email: "wen"
  }

  def fixture(:user) do
    {:ok, user} = Users.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_user]

    test "lists all users", %{conn: conn} do
      conn =
        post(conn, "/api/login", %{username: "kawen", password: "imkawen"})
        |> get(Routes.user_path(conn, :index))

      assert length(json_response(conn, 200)["data"]) == 1
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn =
        post(conn, "/api/login", %{username: "kawen", password: "imkawen"})
        |> put(Routes.user_path(conn, :update, user), user: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn =
        post(conn, "/api/login", %{username: "kawen", password: "imkawen"})
        |> put(Routes.user_path(conn, :update, user), user: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn =
        post(conn, "/api/login", %{username: "kawen", password: "imkawen"})
        |> delete(Routes.user_path(conn, :delete, user))

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end
end
