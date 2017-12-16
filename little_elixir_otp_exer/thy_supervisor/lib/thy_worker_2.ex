defmodule ThyWorker2 do
  def start_link do
    spawn(fn -> loop() end)
  end

  def loop do
    receive do
      :stop -> :ok

      msg ->
        IO.inspect("Thy Worker 2: #{msg}")
        loop()
    end
  end

end
