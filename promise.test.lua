local Promise = require("promise")

local promise =
  Promise.create(
  function(resolve, reject)
    print("before")
    local current = os.clock()
    local time_point = 1
    while os.clock() < current + time_point do
      --nothing
      -- coroutine.yield()
    end
    resolve("res")
    -- if true then
    -- else
    --   reject("err")
    -- end
  end
)

promise.done(
  function(val)
    print("================")
    print(val)
    print("================")
  end
)

print("concurrent?")

local p2 =
  Promise.create(
  function(resolve)
    resolve("jaja")
  end
)

-- p2.done(
--   function(res)
--     print(res)
--     return "done return 1"
--   end
-- ).done(
--   function(res)
--     print(res)
--     return "done return 2"
--   end
-- ).done(
--   function(res)
--     print(res)
--     return "done return 3"
--   end
-- ).done(
--   function(res)
--     print(res)
--     return "done return 4"
--   end
-- ).done(
--   function(res)
--     print(res)
--     return "done return 5"
--   end
-- ).done(
--   function(res)
--     print(res)
--     return "done return 6"
--   end
-- )

local p3 = Promise.create()

print("type ", type(p3))

p3.done(
  function(res)
    print(res)
    return "done return 1"
  end
).done(
  function(res)
    print(res)
    return "done return 2"
  end
).done(
  function(res)
    print(res)
    return p2
  end
).done(
  function(res)
    print(res)
  end
)

-- local p4 =
--   Promise.create(
--   function(resolve, reject)
--     print("before")
--     local current = os.clock()
--     local time_point = 1
--     while os.clock() < current + time_point do
--       --nothing
--     end
--     resolve("res")
--     -- if true then
--     -- else
--     --   reject("err")
--     -- end
--   end
-- )
-- print("concurrent?")

-- p4.done(
--   function(val)
--     print(val)
--   end
-- )
