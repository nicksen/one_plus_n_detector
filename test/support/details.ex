defmodule OnePlusNDetector.Details do
  use Ecto.Schema

  schema "users_details" do
    belongs_to(:user, OnePlusNDetector.User)
  end
end
