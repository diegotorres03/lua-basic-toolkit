local Node = {}

local Link = require("./link")

--[[
  Node class represent each node on the graph
  each node has a list of links
]]
Node.create = function(params)
  local instance = {
    id = "",
    type = "",
    properties = {},
    links = {}
  }
  if params then
    instance.id = params.id
    instance.type = params.type
    instance.properties = params.properties
  end

  -- Add a node to anoder node
  instance.to = function(node, link_type, properties)
    local link =
      Link.create(
      {
        source = instance.id,
        target = node.id,
        type = link_type or "",
        properties = properties or {}
      }
    )
    table.insert(instance.links, link)
    return node
  end

  -- check if is a leaf node
  instance.is_leaf = function()
    return table.maxn(instance.links) == 0
  end

  instance.tostring = function()
    local str = "(%s:%s) =>\n"
    for i, link in pairs(instance.links) do
      str = str .. string.format("\t-[%s:%s]->(%s)\n", link.id or "jaja", link.type, link.target)
    end
    local id = instance.id
    local type = instance.type
    local res_str = string.format(str, id, type, "n", "r", "m", "n", "r", "m", "n", "r", "m")
    -- print(str)
    return res_str
  end

  return instance
end

return Node
