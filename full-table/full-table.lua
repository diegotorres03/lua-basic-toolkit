local Table = {}

Table.foreach = function(items, callback)
  for index, item in pairs(items) do
    callback(item, index, items)
  end
  return items
end

Table.map = function(items, callback)
  local newTable = {}
  for index, item in pairs(items) do
    newTable[index] = callback(item, index, items)
  end
  return newTable
end

Table.filter = function(items, callback)
  local newTable = {}
  for index, item in pairs(items) do
    local allowed = callback(item, index, items)
    if allowed then
      newTable[index] = item
    end
  end
  return newTable
end

Table.create = function(tableArray)
  local fullTable = {}

  -- get keys
  fullTable["keys"] = function()
    local res = {}
    local index = 1
    for k, v in pairs(tableArray) do
      res[index] = k
      index = index + 1
    end
    return res
  end
  -- get values
  fullTable["values"] = function()
    local res = {}
    local index = 1
    for k, v in pairs(tableArray) do
      res[index] = v
      index = index + 1
    end
    return res
  end
  -- get entries
  fullTable["entries"] = function(index)
    if index then
      return tableArray[index]
    end
    return tableArray
  end

  -- foreach items
  fullTable["foreach"] = function(callback)
    Table.foreach(tableArray, callback)
  end
  -- map items
  fullTable["map"] = function(callback)
    local res = Table.map(tableArray, callback)
    return Table.create(res)
  end
  -- filter items
  fullTable["filter"] = function(callback)
    local res = Table.filter(tableArray, callback)
    return Table.create(res)
  end
  return fullTable
end

return Table
