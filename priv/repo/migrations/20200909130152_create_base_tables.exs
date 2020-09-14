defmodule Raijin.Repo.Migrations.CreateBaseTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext"

    create table("users", primary_key: false) do
      add :id, :uuid, primary_key: true
      add :username, :citext, null: false
      add :email, :citext, null: false
      add :password_hash, :text
      add :admin, :boolean

      timestamps()
    end

    create table("uploads", primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references("users", type: :uuid)
      add :path, :text

      timestamps()
    end

    create unique_index("users", [:username])
    create unique_index("users", [:email])
  end
end
