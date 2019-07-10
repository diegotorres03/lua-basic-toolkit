local Promise = {}

local global_promise_co = {}

local loop = function()
  if is_looping == true then
    return
  end
  is_looping = true
  print("looping\n\n", #global_promise_co)
  while #global_promise_co > 1 do
    -- while 1 do
    -- print(#global_promise_co, global_promise_co)
    for k, v in pairs(global_promise_co) do
      -- print(k, v)
      if coroutine.status(v) == "dead" then
        table.remove(global_promise_co, k)
      end
      coroutine.resume(v)
      -- print(coroutine.resume(v))
    end
  end
end

local is_looping = false

Promise.create = function(future)
  local promise = {}
  if future == nil then
    future = function(resolve)
      resolve()
    end
  end

  local future_co =
    coroutine.create(
    function()
      function resolve(data)
        coroutine.yield(data)
      end

      function reject(err)
        coroutine.yield(err)
      end
      future(resolve, reject)
      -- coroutine.yield("pause")
    end
  )
  table.insert(global_promise_co, future_co)

  loop()

  promise.done = function(callback)
    local success, value = coroutine.resume(future_co)
    local done_return = callback(value)
    for key, co in pairs(global_promise_co) do
      if co == future_co then
        table.remove(global_promise_co, key)
      end
    end
    if done_return then
      return done_return.done and done_return or
        Promise.create(
          function(resolve)
            resolve(done_return)
          end
        )
    end
  end

  -- promise.fail = function(callback)
  --   local success, value = coroutine.resume(future_co)
  --   -- print("inside done definition", success, value)
  --   callback(value)
  -- end

  return promise
end

return Promise
