defmodule OnePlusNDetector.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Feedz.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL.Sandbox, as: SQLSandbox

  using do
    quote do
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  setup tags do
    pid = SQLSandbox.start_owner!(OnePlusNDetector.Repo, shared: not tags[:async])
    on_exit(fn -> SQLSandbox.stop_owner(pid) end)
    :ok
  end
end
