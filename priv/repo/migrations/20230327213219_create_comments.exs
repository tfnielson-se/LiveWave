defmodule Livewave.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :forum_id, references(:forums, on_delete: :nothing)

      timestamps()
    end

    create index(:comments, [:user_id])
    create index(:comments, [:forum_id])
  end
end
