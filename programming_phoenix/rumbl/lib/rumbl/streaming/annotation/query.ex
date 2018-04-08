defmodule Rumbl.Streaming.Annotation.Query do
  import Ecto.Query

  def wrote_by(queryable, user_id) when is_integer(user_id) do
    from a in queryable, where: a.user_id == ^user_id
  end

  def in_video(queryable, video_id) when is_integer(video_id) do
    from a in queryable, where: a.video_id == ^video_id
  end

  def first(queryable, limit) do
    from a in queryable,
      order_by: [asc: a.at, asc: a.id],
      limit: ^limit
  end

  # Note: I don't like that we're relying on the order of ID. We should've
  # used the timestamps.
  def after_id(queryable, id) do
    from v in queryable, where: v.id > ^id
  end
end
