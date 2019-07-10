local Test = require("test")
local Sandbox = require("sandbox")
local it = Test.it

print("Sandbox functions")

print("Sandbox instance")
it(
  "should create an instance",
  function(assert)
    local sandbox = Sandbox.create()
    assert(sandbox, "sandbox ~= nil")
    assert(type(sandbox.has) == "function", "type(sandbox.has) == " .. type(sandbox.has))
    assert(type(sandbox.get) == "function", "type(sandbox.get) == " .. type(sandbox.get))
    assert(type(sandbox.set) == "function", "type(sandbox.set) == " .. type(sandbox.set))
    assert(type(sandbox.on) == "function", "type(sandbox.on) == " .. type(sandbox.on))
    assert(type(sandbox.emit) == "function", "type(sandbox.emit) == " .. type(sandbox.emit))
  end
)

it(
  "should emit an event and should be listened",
  function(assert)
    local sandbox = Sandbox.create()
    function done(index)
      return function(value)
        assert(value == "TEST_VALUE", "value == TEST_VALUE on listener #" .. index)
      end
    end

    sandbox.on("TEST_EVENT", done(1))
    sandbox.on("TEST_EVENT", done(2))
    sandbox.emit("TEST_EVENT", "TEST_VALUE")
  end
)

it(
  "should unsubcribe then emit an event and should not be listened",
  function(assert)
    local sandbox = Sandbox.create()
    local not_visited = true
    function done(value)
      not_visited = false
    end

    sandbox.on("TEST_EVENT", done)
    sandbox.off("TEST_EVENT", done)
    sandbox.emit("TEST_EVENT", "TEST_VALUE")
    assert(not_visited, "not_visited should be true")
  end
)

it(
  "should save an event on store when emited",
  function(assert)
    local original_value = "test_value"
    local sandbox = Sandbox.create()
    function done(value)
    end

    sandbox.on("TEST_EVENT", done)
    sandbox.emit("TEST_EVENT", original_value)
    local store_value = sandbox.get("TEST_EVENT")

    assert(store_value == original_value, "store_value == original_value")
  end
)
