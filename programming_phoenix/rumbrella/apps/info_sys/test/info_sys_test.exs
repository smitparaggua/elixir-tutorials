defmodule InfoSysTest do
  use ExUnit.Case
  alias InfoSys.Result

  defmodule TestBackend do
    def start_link(query, ref, owner, limit) do
      Task.start_link(__MODULE__, :fetch, [query, ref, owner, limit])
    end

    def fetch("result", ref, owner, _limit) do
      send(owner, {:results, ref, [%Result{backend: "test", text: "result"}]})
    end

    def fetch("none", ref, owner, _limit) do
      send(owner, {:results, ref, [%Result{backend: "test", text: "result"}]})
    end
  end

  test "compute/2 with backend results" do
    # TODO here
  end
end
