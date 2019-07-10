local Sandbox = {}

Sandbox.off = function(event_list, event_name, callback)
  if event_list[event_name] == nil then
    event_list[event_name] = {}
  end
  local event_callbacks = event_list[event_name]
  for index, event_callback in pairs(event_callbacks) do
    if (event_callback == callback) then
      event_list[event_name] = nil
    end
  end
end

Sandbox.on = function(event_list, event_name, callback)
  if event_list[event_name] == nil then
    event_list[event_name] = {}
  end
  local event_callback = event_list[event_name]
  event_callback[#event_callback + 1] = callback
end

Sandbox.emit = function(event_list, event_name, data)
  local event_callbacks = event_list[event_name]
  if event_callbacks then
    for index, event_callback in pairs(event_callbacks) do
      if event_callback then
        event_callback(data)
      end
    end
  end
end

function Sandbox.create()
  local sandbox = {}
  local event_list = {}
  local ask_listeners = {}
  local store = {}

  sandbox.has = function(event_name)
    return store[event_name] and true
  end

  sandbox.get = function(event_name)
    return store[event_name]
  end

  sandbox.set = function(event_name, data)
    store[event_name] = data
    table.insert(store, event_name, data)
  end

  sandbox.delete = function(event_name)
    table.remove(store, event_name)
    -- store[event_name] = data
  end
  sandbox.clear = function(event_name, data)
    store = {}
  end

  sandbox.on = function(event_name, callback)
    Sandbox.on(event_list, event_name, callback)
  end

  sandbox.off = function(event_name, callback)
    Sandbox.off(event_list, event_name, callback)
  end

  sandbox.emit = function(event_name, data)
    store[event_name] = data
    Sandbox.emit(event_list, event_name, data)
  end

  return sandbox
end

return Sandbox
