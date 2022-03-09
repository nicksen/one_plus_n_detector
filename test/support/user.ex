defmodule OnePlusNDetector.User do
  use Ecto.Schema

  schema "users" do
    has_one(:details, OnePlusNDetector.Details)
  end
end
