defmodule Rumbl.TestHelpers.Streaming do
  alias Rumbl.Streaming

  def create_video(attrs \\ %{}) do
    defaults = %{
      url: "https://www.youtube.com/watch?v=i1UNSTXQhCA",
      description: "Pure awesomeness"
    }

    defaults
    |> Map.merge(attrs)
    |> Streaming.create_video()
  end

  defdelegate get_video_by!(attrs), to: Streaming
end
