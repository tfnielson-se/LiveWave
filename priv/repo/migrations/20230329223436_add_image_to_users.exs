defmodule Livewave.Repo.Migrations.AddImageToUsers do
  use Ecto.Migration

  def change do
    alter table (:users) do
      add :image, :string
    end
  end
end
