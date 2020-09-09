defmodule Raijin.Uploads.Upload do
  use Ecto.Schema
  import Ecto.Changeset
  alias Raijin.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "uploads" do
    belongs_to :creator, User
    field :path, :string

    timestamps()
  end

  @doc false
  def changeset(upload, attrs) do
    upload
    |> cast(attrs, [])
    |> validate_required([])
  end
end
