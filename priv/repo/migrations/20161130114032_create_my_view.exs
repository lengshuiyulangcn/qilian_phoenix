defmodule QilianPhoenix.Repo.Migrations.CreateMyView do
  use Ecto.Migration

  def change do
    create table(:my_views) do
      add :path, :string
      add :content, :text

      timestamps()
    end

  end
end
