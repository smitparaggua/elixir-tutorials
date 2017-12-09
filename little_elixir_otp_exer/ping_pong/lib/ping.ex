defmodule PingPong.Ping do
  def listen() do
    receive do
      {sender_pid, :pong} ->
        IO.puts("Received pong")
        Process.send_after(sender_pid, {self(), :ping}, 1000)
      message ->
        IO.puts("Received unknown message:")
        IO.inspect(message)
    end
    listen()
  end
end
