local pinError = 1
local pinInfo = 2
local pin = 5

print("hola?")

gpio.mode(pinError, gpio.OUTPUT)
gpio.write(pinError, gpio.HIGH)

gpio.mode(pinInfo, gpio.OUTPUT)
gpio.write(pinInfo, gpio.LOW)

gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, gpio.LOW)

local isOn = false

function close(sck)
  sck:close()
  gpio.write(pinInfo, gpio.LOW)
end

function router(conn)
  gpio.write(pinInfo, gpio.HIGH)
  conn:on(
    "receive",
    function(sck, request)
      if request then
        local method = string.sub(request, 1, 4)
        print("using" .. method)
        print("request\n" .. request)

        sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n" .. request)
      -- sck:send('{"success": true, "value": false, "method": "' .. method .. ' "extra:" ' .. request .. '"}')
      -- sck:send('{"success": true, "value": false, "method": "' .. method .. ' "extra:" ' .. request .. '"}')
      -- if method == "POST" then
      -- end
      end
    end
  )
  conn:on("sent", close)
end

function createServer()
  srv = net.createServer(net.TCP)
  if srv then
    srv:listen(80, router)
  end
end
wifi.setmode(wifi.STATION)
ip = wifi.sta.getip()
if ip then
  print("\nIP Address: " .. ip)
else
  -- print(wifi)
  print("\n no Ip assigned")
end
wifi.sta.config({ssid = "Diego LG", pwd = "clave1234"})

wifi.sta.connect(
  function()
    gpio.write(pinError, gpio.LOW)
    -- gpio.write(pinInfo, gpio.HIGH)
    createServer()
  end
)

-- gpio.write(pinError, gpio.LOW)
