import Ecto.Query
alias Rumbl.Repo
alias Rumbl.Streaming.Video

videos_without_slug = from v in Video, where: is_nil(v.slug)

slugify = fn str ->
  str
  |> String.downcase()
  |> String.replace(~r/[^\w-]+/u, "-")
end

for video <- Repo.all(videos_without_slug) do
  slug = slugify.(video.title)
  video
  |> Ecto.Changeset.change(%{slug: slug})
  |> Repo.update()
end
