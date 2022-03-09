defmodule OnePlusNDetector.DetectorTest do
  use OnePlusNDetector.DataCase
  import Ecto.Query
  alias OnePlusNDetector.Details
  alias OnePlusNDetector.Detector
  alias OnePlusNDetector.ReadReplica
  alias OnePlusNDetector.Repo
  alias OnePlusNDetector.User

  describe "detector" do
    setup do
      users =
        for _ <- 1..10 do
          user = Repo.insert!(%User{})
          Repo.insert!(%Details{user_id: user.id})
          user
        end

      GenServer.call(Detector, :reset)

      [users: users]
    end

    test "counts how many times the same query was run" do
      User
      |> Repo.all()
      |> Enum.map(fn u -> Repo.preload(u, [:details]) end)

      assert %{count: count} = Detector.current()
      assert count == 10
    end

    test "resets counter if it detects a new query was run", %{users: users} do
      for %{id: id} <- users do
        q =
          from(u in User,
            where: u.id == ^id,
            preload: [:details]
          )

        Repo.one!(q)
      end

      %{count: count} = Detector.current()
      assert count == 1
    end

    test "resets counter if the query isn't a select query" do
      users = Repo.all(User)
      {first_batch, second_batch} = Enum.split(users, 5)
      Enum.map(first_batch, fn u -> Repo.preload(u, [:details]) end)

      for user <- users do
        Repo.insert!(%Details{user_id: user.id})
      end

      Enum.map(second_batch, fn u -> Repo.preload(u, [:details]) end)
      %{count: count} = Detector.current()
      assert count == 5
    end

    test "detection is aggregated over all repos" do
      users = Repo.all(User)

      users
      |> Enum.take(5)
      |> Enum.map(fn u -> Repo.preload(u, [:details]) end)

      users
      |> Enum.drop(5)
      |> Enum.map(fn u -> ReadReplica.preload(u, [:details]) end)

      %{count: count} = Detector.current()
      assert count == 10
    end
  end
end
