-- thread master

-- parralell function

local async1 =
  coroutine.create(
  function()
    local current = os.clock()
    local time_point = 0.2
    while os.clock() < current + time_point do
      coroutine.yield(string.format("async 1: %f", os.clock()))
    end
    coroutine.yield("done 1")
  end
)
local async2 =
  coroutine.create(
  function()
    local current = os.clock()
    local time_point = 0.3
    while os.clock() < current + time_point do
      coroutine.yield(string.format("async 2: %f", os.clock()))
    end
    coroutine.yield("done 2")
  end
)
local async3 =
  coroutine.create(
  function()
    local input = nil
    while input == nil do
      input = io.read()
      coroutine.yield(string.format("async 3: %f", os.clock()))
    end
    coroutine.yield("done 3")
  end
)

print("is blocking me?")

local Parallel = {}
Parallel.create = function(...)
  local process_list = {}
  local last_return = {}
  for i, func_co in ipairs(arg) do
    process_list[i] = func_co
  end

  print("#process_list", #process_list)

  local stop = false
  while stop == false do
    stop = true
    for i, func_co in ipairs(process_list) do
      local dead = coroutine.status(func_co) == "dead"
      stop = stop and dead
      if dead == false then
        done, more = coroutine.resume(process_list[i])
        last_return[i] = last_return[i] or more
      end
    end
  end
  return function(callback)
    callback(last_return)
  end
end

local on_done = Parallel.create(async1, async2, async3)

on_done(
  function(res)
    for index, item in ipairs(res) do
      print(item)
    end
  end
)
