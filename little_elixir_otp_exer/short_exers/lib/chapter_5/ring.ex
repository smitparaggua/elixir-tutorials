defmodule Ring do
  def create_processes(n) do
    1..n |> Enum.map(fn _ -> spawn(fn -> loop() end) end)
  end

  def loop do
    receive do
      {:link, link_to} when is_pid(link_to) ->
        Process.link(link_to)
        loop()

      {:EXIT, pid, reason} ->
        IO.puts("#{inspect self}, received {:EXIT, #{inspect pid}, #{reason}")
        loop()

      :trap_exit ->
        Process.flag(:trap_exit, true)
        loop()

      :crash -> 1/0
    end
  end

  def link_processes(procs) do
    link_processes(procs, [])
  end

  defp link_processes([proc_1, proc_2 | rest], linked_procs) do
    send(proc_1, {:link, proc_2})
    link_processes([proc_2 | rest], [proc_1 | linked_procs])
  end

  defp link_processes([proc], linked_procs) do
    send(proc, {:link, List.last(linked_procs)})
    :ok
  end
end
