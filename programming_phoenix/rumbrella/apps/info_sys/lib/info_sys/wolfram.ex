defmodule InfoSys.Wolfram do
  import SweetXml
  alias InfoSys.Result

  def start_link(query, query_ref, owner, limit) do
    Task.start_link(__MODULE__, :fetch, [query, query_ref, owner, limit])
  end

  def fetch(query_string, query_ref, owner, _limit) do
    xpath_to_extract =
      ~x"/queryresult/pod
      [contains(@title, 'Result') or contains(@title, 'Definitions')]
      /subpod/plaintext/text()"

    query_string
    |> fetch_xml()
    |> xpath(xpath_to_extract)
    |> send_results(query_ref, owner)
  end

  defp send_results(nil, query_ref, owner) do
    send(owner, {:results, query_ref, []})
  end

  defp send_results(answer, query_ref, owner) do
    results = [%Result{backend: "wolfram", score: 95, text: to_string(answer)}]
    send(owner, {:results, query_ref, results})
  end

  defp fetch_xml(query_string) do
    url = "http://api.wolframalpha.com/v2/query" <>
      "?appid=#{app_id()}&input=#{URI.encode(query_string)}&format=plaintext"
    {:ok, {_, _, body}} =
      url
      |> String.to_charlist()
      |> :httpc.request()

    body
  end

  defp app_id, do: Application.get_env(:info_sys, :wolfram)[:app_id]
end
