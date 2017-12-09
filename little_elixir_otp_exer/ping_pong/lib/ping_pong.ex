defmodule PingPong do
  alias PingPong.Ping
  alias PingPong.Pong

  def ping_pong() do
    pong_pid = spawn(Pong, :listen, [])
    ping_pid = spawn(Ping, :listen, [])
    send(ping_pid, {pong_pid, :pong})
    {ping_pid, pong_pid}
  end
end
