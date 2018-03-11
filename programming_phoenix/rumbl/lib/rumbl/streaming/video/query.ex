defmodule Rumbl.Streaming.Video.Query do
  import Ecto.Query, warn: false

  def count(queryable) do
    from v in queryable, select: count(v.id)
  end

  def owned_by(queryable, owner_id) do
    from v in queryable, where: v.owner_id == ^owner_id
  end
end
