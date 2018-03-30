defmodule Rumbl.StreamingTestHelpers do
  alias Rumbl.Streaming
  alias Streaming.Video

  def create_video(attrs \\ %{}) do
    attrs
    |> video_attrs()
    |> Streaming.create_video()
  end

  def build_video(attrs \\ %{}) do
    attrs
    |> video_attrs()
    |> (&struct(Video, &1)).()
  end

  defp video_attrs(custom) do
    defaults = %{
      title: "Rain",
      url: "https://www.youtube.com/watch?v=i1UNSTXQhCA",
      description: "Pure awesomeness"
    }

    defaults
    |> Map.merge(custom)
  end

  defdelegate get_video_by!(attrs), to: Streaming
  defdelegate number_of_videos, to: Streaming
  defdelegate change_video(attrs \\ %Video{}), to: Streaming
end
