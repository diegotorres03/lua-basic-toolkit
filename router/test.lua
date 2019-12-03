local EasyApi = require "easy-api"

local api = EasyApi()

-- THIS IS EXAMPLE USE OF API

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

api.get(
    "/user/(.-)/events/(.-)/other/(.-)?",
    function(req)
        print("with other")
    end
)

api.get(
    "/test?",
    function(req)
        print("insideee test")
        return "done", 200
    end
)

-- local rawEvent =
--     [[GET /user/54321/events/2342?prop1=val1&prop2=val2&prop3=val3 HTTP/1.1
-- Host: easyarchery.net
-- Content-Type: application/json
-- Content-Length: 1234

-- field1=value1&field2=value2
-- field1=value1&field2=value2
-- ]]

local rawEvent =
    [[POST /test?a=b HTTP/1.1
Content-Type: application/json
User-Agent: PostmanRuntime/7.19.0
Accept: */*
Cache-Control: no-cache
Postman-Token: d0a64b91-079e-45d5-8206-bbdf9de722d4
Host: 192.168.43.223:8081
Accept-Encoding: gzip, deflate
Connection: keep-alive

jaja=haha]]
-- [[GET /test?q1=uno HTTP/1.1
-- User-Agent: Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.18362.145
-- Host: 192.168.43.223:8081
-- Connection: Keep-Alive

-- field1=value1&field2=value2
-- ]]

api.handle(rawEvent)

local str =
    [[Content-Type: application/json
User-Agent: PostmanRuntime/7.19.0
Accept: */*
Cache-Control: no-cache
Postman-Token: d0a64b91-079e-45d5-8206-bbdf9de722d4
Host: 192.168.43.223:8081
Accept-Encoding: gzip, deflate
Connection: keep-alive

jaja=haha]]

-- print(str)

-- print("===================")
-- print(str:match("[\n].-$"))

local headers = {}
local isBody = false
local body = {}

-- for line in str:gmatch(".-[\n]") do
--     print("->", trim(line))
--     if line:find(":") ~= nil then
--         local key, val = line:match("^(.-)[:](.-)$")
--         print(key, ":", val)
--         headers[trim(key)] = trim(val)
--     end

--     if isBody == false then
--         if line == nil or trim(line) == "" then
--             isBody = true
--         end
--     end

--     if line:find("=") then
--         body = getQueryTable("?" .. trim(line))
--     end
-- end

-- print(headers.Host)
-- print(body.jaja)
