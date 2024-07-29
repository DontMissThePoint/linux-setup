socket = require "socket"

function fade_out()
  for i=0,20,1 do
    contrast = -5 * i
    volume = math.min(100, 200 - 10 * i)

    mp.set_property("contrast", contrast)
    mp.set_property("volume", volume)

    socket.sleep(0.03)
  end

  mp.command("quit")
end

mp.add_key_binding("ctrl+q", fade_out)
