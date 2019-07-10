function Relation()
  local instance = {
    key = "",
    name = "",
    neighbors = {}
  }

  return instance
end

local test = Relation()

print("test.key")
print(test.key)
print("test.name")
print(test.name)
