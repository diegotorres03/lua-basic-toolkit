local EasyApi = require "easy-api"

local api = {}
-- print("testint EasyRouter")

function setRoutes(api)
  api.get(
    "/",
    function(req)
      print("route /")
      return '{"success": true}', 200
    end
  )
  -- api.get(
  --   "/test?",
  --   function(req)
  --     print("route /test?")
  --     return '{"success": true}', 200
  --   end
  -- )

  api.post(
    "/user/(.-)/events",
    function(req)
      print("sin ?")
      local userId = req.params[1]
      local body = req.body
      print("on route", req.path, "userId", userId)
      print("body", body.oe, body.prop2, body.prop3)
      return true
    end
  )
  api.get(
    "/user/(.-)/events/(.-)?",
    function(req)
      local userId = req.params[1]
      local eventId = req.params[2]
      local query = req.query
      print("on route", req.path, "userId", userId, "eventId", eventId)
      print("query", query.prop1, query.prop2, query.prop3)
    end
  )
end

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
  print("creating server")
  srv = net.createServer(net.TCP)
  if srv == nil then
    print("server not created")
    return
  end
  print("server created")
  srv:listen(
    8081,
    function(conn)
      print("listening to connections")
      conn:on(
        "receive",
        function(sck, rawRequest)
          -- print('on req')
          print(rawRequest)
          local success, res =
            pcall(
            function()
              -- print("handling req")
              -- return "jeje"
              local response, status = api.handle(rawRequest)
              print(response, status)
              return response
            end
          )
          if success == false then
            print('error', res)
            -- return "internal card error", 500
            return sck:send("HTTP/1.0 500 Internal\r\nContent-Type: text/html\r\n\r\n<h1> Internal Error.</h1>")
          end
          print(success, res)
          -- sck:send("haha")
          if res == nil then
            return sck:send("HTTP/1.0 404 OK\r\nContent-Type: text/html\r\n\r\n" .. rawRequest)
          end
          sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n" .. rawRequest)
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

function run()
  print("inside run function")
  wifi.sta.connect(
    function()
      print("connecting to wifi")
      -- printIp()
      api = EasyApi()
      setRoutes(api)
      createServer()
    end
  )
end

local p1, p2 = pcall(run)
print(p1, p2)
if p1 then
  print("running")
else
  print("error running")
end
