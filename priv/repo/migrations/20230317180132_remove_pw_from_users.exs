defmodule Livewave.Repo.Migrations.RemovePwFromUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :password_hash
    end
  end
end
