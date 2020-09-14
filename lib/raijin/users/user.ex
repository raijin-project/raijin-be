defmodule Raijin.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :username, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :admin, :boolean

    has_many :uploads, Raijin.Uploads.Upload

    timestamps()
  end

  @doc false
  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :admin])
    |> validate_required([:username, :email, :password])
    |> validate_length(:username, min: 3, max: 50)
    |> validate_length(:password, min: 5, max: 50)
    |> validate_format(:email, ~r/@/)
    |> put_pass_hash()
    |> delete_change(:password)
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password_hash, :admin])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5, max: 50)
    |> put_pass_hash()
    |> delete_change(:password)
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Pbkdf2.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
