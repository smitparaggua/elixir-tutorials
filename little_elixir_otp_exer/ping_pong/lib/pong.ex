defmodule PingPong.Pong do
  def listen() do
    receive do
      {sender_pid, :ping} ->
        IO.puts("Received ping")
        Process.send_after(sender_pid, {self(), :pong}, 1000)
      message ->
        IO.puts("Received unknown message:")
        IO.inspect(message)
    end
    listen()
  end
end
