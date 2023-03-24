defmodule Livewave.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :chatroom_id, references(:chatrooms, on_delete: :nothing)

      timestamps()
    end

    create index(:messages, [:user_id])
    create index(:messages, [:chatroom_id])
  end
end
