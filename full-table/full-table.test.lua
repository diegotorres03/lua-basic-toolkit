local Test = require("test")
local Table = require("full-table")

for message, valid in pairs(Table) do
  print(valid, message)
end

local it = Test.it

print(Table)
print(Table.map)
print(Table.create)
print("MAP")
it(
  "should go trough each element of the table",
  function(assert)
    local testArr = {"item1", "item2", "item3"}

    local count = 0
    local arr = Table.create(testArr)
    arr.foreach(
      function(item, index)
        count = count + 1
      end
    )
    assert(count == 3, "arr lengt = 3")
    -- assert(count ~= 3, "arr lengt = 3")
    -- assert(count == 3, "arr lengt = 3")
  end
)
it(
  "should map each element of the table and return new array",
  function(assert)
    local testArr = {"item1", "item2", "item3"}

    local count = 0
    local arr = Table.create(testArr)
    local copy =
      arr.map(
      function(item, index)
        count = count + 1
        return item .. "-tested"
      end
    )
    assert(count == 3, "count == 3")
    for index, item in pairs(copy.entries()) do
      local supposed = (arr.entries(index) or "") .. "-tested"
      assert(item == supposed, item .. "==" .. supposed)
    end
    -- assert(copy[1] == (arr[1] .. "-tested"), "error here")
  end
)

it(
  "should create an array and chain it on the same line",
  function(assert)
    -- local testArr = {"item1", "item2", "item3"}
    local testArr = {
      it1 = "item1",
      it2 = "item2",
      it3 = "item3"
    }
    function foreach_handle(item, index)
      assert(item == testArr[index], string.format("%s == testArr[%s]", item, index))
    end
    Table.create(testArr).foreach(foreach_handle)
  end
)
