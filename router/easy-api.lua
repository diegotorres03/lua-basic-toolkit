if EasyApi then --luacheck: ignore
    return
end

--- Easy API Router
-- @exports
-- @author Diego Torres
-- @since 11/11/2019
-- @version 1.0.0
local EasyApi = function()
    local handlerStore = {
        get = {},
        post = {},
        put = {},
        delete = {},
        options = {},
        head = {}
    }

    local api = {}

    local handlerStore = {
        get = {},
        post = {},
        put = {},
        delete = {},
        options = {},
        head = {}
    }

    local urlPatterns = {}

    api.registerRouteHandler = function(method, urlPattern, handler)
        print("registering...", method, urlPattern)
        if not handlerStore[method][urlPattern] then
            handlerStore[method][urlPattern] = {}
        end
        urlPatterns[#urlPatterns + 1] = urlPattern
        handlerStore[method][urlPattern] = handler
    end

    -- registering routing methods
    api.get = function(urlPatter, handler)
        api.registerRouteHandler("get", urlPatter, handler)
    end

    api.post = function(urlPatter, handler)
        api.registerRouteHandler("post", urlPatter, handler)
    end

    api.delete = function(urlPatter, handler)
        api.registerRouteHandler("delete", urlPatter, handler)
    end

    api.patch = function(urlPatter, handler)
        api.registerRouteHandler("patch", urlPatter, handler)
    end

    api.put = function(urlPatter, handler)
        api.registerRouteHandler("put", urlPatter, handler)
    end

    api.options = function(urlPatter, handler)
        api.registerRouteHandler("options", urlPatter, handler)
    end

    api.head = function(urlPatter, handler)
        api.registerRouteHandler("head", urlPatter, handler)
    end

    --- main handler, exposed to be used with plain text http requests
    -- @param {table} rawEvent - http in plain text
    api.handle = function(rawEvent)
        local event = rawHttpToEvent(rawEvent)
        local method = string.lower(event.method)
        local urlPattern, params = findUrlPattern(urlPatterns, event)
        local req = deepcopy(event)
        req.params = params
        req.urlPattern = urlPattern
        local routeHandler = handlerStore[method][urlPattern]
        if routeHandler == nil then
            print("no handler for", req.path, "===", urlPattern)
            return nil, 404
        end
        return routeHandler(req)
    end

    return api
end

function getQueryTable(url)
    if (url == nil or url == "") then
        return {}
    end
    local queryString = string.sub((string.match(url, "?.-$")), 2)
    local query = {}
    for queryItem in string.gmatch(queryString, "([^&]+)") do
        local key, val = string.match(queryItem, "(.-)=(.-)$")
        query[key] = val
    end
    return query
end

function trim(str)
    return str:match "^%s*(.-)%s*$"
end

function getPathAndQuery(fullPath)
    local hasQuery = fullPath:match("?")
    if not hasQuery then
        return fullPath, {}
    end
    local path, queryString = fullPath:match("(/.-)?(.-)$")
    local query = getQueryTable("?" .. queryString)
    return path, query
end

function getHeadersAndBody(rawEvent)
    local headers = {}
    local body = {}

    for line in rawEvent:gmatch(".-[\n]") do
        if line:find(":") ~= nil then
            local key, val = line:match("^(.-)[:](.-)$")
            headers[trim(key)] = trim(val)
        end
    end

    local bodyStr = rawEvent:match("[\n][\n].-$")
    print('bodyStr', bodyStr)
    if bodyStr and bodyStr:find("=") then
        body = getQueryTable("?" .. trim(bodyStr))
    end

    return headers, body
end

function rawHttpToEvent(httpString)
    local fullPath = trim(httpString:match("%A.- "))
    local path, query = getPathAndQuery(fullPath)
    local method = trim(httpString:match("^.- "))
    local h, host = httpString:match("(Host: (.-[\r\n]))")
    host = trim(host)
    -- print(
    --     string.format(
    --         [[
    --     event: {
    --         host: %s,
    --         method: %s,
    --         path: %s
    --     }
    -- ]],
    --         host,
    --         method,
    --         path
    --     )
    -- )
    local headers, body = getHeadersAndBody(httpString)
    local event = {
        host = host,
        method = method,
        path = path,
        headers = headers,
        body = body,
        query = query
    }
    return event
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function checkParamsIntegrity(params)
    for index, param in pairs(params) do
        if param == nil then
            return false
        end
        if string.match(param, "/") then
            return false
        end
    end
    return true
end

function findUrlPattern(urlPatterns, event)
    local path = event.path
    for index, pattern in pairs(urlPatterns) do
        print(event.path, "===", pattern)
        local params = {string.match(path .. "?", pattern)}
        if checkParamsIntegrity(params) then
            return pattern, params
        end
    end
end

return EasyApi
