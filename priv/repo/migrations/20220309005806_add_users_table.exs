defmodule OnePlusNDetector.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
    end

	create table(:users_details) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
	end

    create index(:users_details, [:user_id])
  end
end
