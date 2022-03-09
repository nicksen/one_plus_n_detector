defmodule OnePlusNDetector.Detector do
  @moduledoc """
  Checks a query against the previous one and increments a counter of collisions or swaps previous query with the last one.
  """

  use GenServer, start: {__MODULE__, :start_link, []}

  # Increase counter or swaps query
  def check("SELECT" <> _rest = query) do
    GenServer.call(__MODULE__, {:check, query})
  end

  def check(_query) do
    GenServer.call(__MODULE__, :reset)
  end

  def current do
    GenServer.call(__MODULE__, :get)
  end

  # GenServer callbacks

  def start_link do
    register_with_repos()
    GenServer.start_link(__MODULE__, %{query: nil, count: 0}, name: __MODULE__)
  end

  def handle_event(_event_name, _measurements, %{query: query}, _config) do
    check(query)
  end

  @impl GenServer
  def init(state) do
    {:ok, state}
  end

  @impl GenServer
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @impl GenServer
  def handle_call({:check, query}, _from, %{query: query, count: count} = state) do
    {:reply, {:match, query, count + 1}, Map.put(state, :count, count + 1)}
  end

  @impl GenServer
  def handle_call({:check, query}, _from, %{query: previous_query, count: previous_count}) do
    {:reply, {:no_match, previous_query, previous_count}, %{query: query, count: 1}}
  end

  @impl GenServer
  def handle_call(:reset, _from, %{query: previous_query, count: previous_count}) do
    {:reply, {:no_match, previous_query, previous_count}, %{query: nil, count: 0}}
  end

  defp register_with_repos do
    repos = Application.get_env(:one_plus_n_detector, :ecto_repos)

    events =
      for repo <- repos do
        telemetry_prefix = repo.config()[:telemetry_prefix]
        telemetry_prefix ++ [:query]
      end

    :ok = :telemetry.attach_many("one-plus-n-detector", events, &__MODULE__.handle_event/4, %{})
  end
end
