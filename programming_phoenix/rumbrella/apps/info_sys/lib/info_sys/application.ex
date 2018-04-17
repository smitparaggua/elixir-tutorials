defmodule InfoSys.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    InfoSys.Supervisor.start_link()
  end
end
