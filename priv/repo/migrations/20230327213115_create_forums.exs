defmodule Livewave.Repo.Migrations.CreateForums do
  use Ecto.Migration

  def change do
    create table(:forums) do
      add :name, :string

      timestamps()
    end
  end
end
