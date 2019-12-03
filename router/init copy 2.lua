-- local EasyApi = require "easy-api"

-- local api = EasyApi()

-- print("testint EasyRouter")

-- api.get(
--   "/test?",
--   function(req)
--     print("is working?")
--     return '{"success": true}', 200
--   end
-- )

-- api.get(
--   "/user/(.-)/events/(.-)?",
--   function(req)
--     print("is working")
--     return '{"success": true}', 200
--   end
-- )

wifi.setmode(wifi.STATION)
wifi.sta.config({ssid = "DiegoLG", pwd = "clave1234"})
-- wifi.sta.config({ssid = "TorresLeon", pwd = "1qa2ws3ed."})

function printIp()
  ip = wifi.sta.getip()
  if ip then
    print("\nIP Address: " .. ip)
    return true
  else
    -- print(wifi)
    print("\n no Ip assigned")
    return false
  end
end

printIp()

function createServer()
  srv = net.createServer(net.TCP)
  if srv then
    srv:listen(
      8081,
      function(conn)
        conn:on(
          "receive",
          function(sck, rawRequest)
            print('on req')
            -- print(rawRequest)
            -- local x, y =
            --   pcall(
            --   function()
            --     print("handling req")
            --     -- local response, status = api.handle(rawRequest)
            --     -- print(response, status)
            --   end
            -- )
            -- print(x, y)
            sck:send("haha")
            -- sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n" .. rawRequest)
            -- sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<h1> Hello, NodeMCU.</h1>")
          end
        )
        conn:on(
          "sent",
          function(sck)
            sck:close()
          end
        )
      end
    )
  end
end

function run()
  -- wifi.sta.connect(
  --   function()
  --     printIp()
  --     createServer()
  --   end
  -- )
end

local p1, p2 = pcall(run)
print(p1, p2)
if p1 then
  print("running")
else
  print("error running")
end
