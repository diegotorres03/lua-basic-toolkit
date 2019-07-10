function Link(params)
  local instance = {
    id = "",
    type = "",
    source = {},
    target = {},
    value = 0,
    properties = {}
  }
  if params then
    instance.id = params.id
    instance.properties = params.properties
    instance.source = params.source
    instance.target = params.target
    instance.type = params.type
    instance.value = params.value
  end
  return instance
end

--[[
  Node class represent each node on the graph
  each node has a list of links
]]
function Node(params)
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
      Link(
      {
        source = instance.id,
        target = node.id,
        type = link_type or "",
        properties = properties or {}
      }
    )
    table.insert(instance.links, link)
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

-- //////////////////////////////////////////
-- GRAPH Class
-- //////////////////////////////////////////

function get_root_nodes(nodes)
  local root_nodes = {}
  for node_id, node in pairs(nodes) do
    root_nodes[node_id] = node
  end
  for node_id, node in pairs(nodes) do
    for link_id, link in pairs(node.links) do
      table.remove(root_nodes, link.target)
    end
  end
  return root_nodes
end

function find_node(nodes, query)
  local response = {}
  if query and query.type then
    for node_id, node in pairs(nodes) do
      if node.type == query.type then
        table.insert(respohse, node)
      end
    end
  end
  if query and query.properties then
    for node_id, node in pairs(nodes) do
      for key, val in pairs(node.properties) do
        if node.properties[key] == query.properties[key] then
          table.insert(respohse, node)
        end
      end
    end
  end
  return response
end

function Graph(name, template)
  local instance = {
    name = "",
    nodes = {},
    links = {}
  }
  if name then
    instance.name = name
  end
  if template then
    instance.name = template.name
    instance.nodes = template.nodes
    instance.links = template.links
  end

  instance.add_node = function(node)
    instance.nodes[node.id] = node
  end

  instance.get_node = function(node)
    return instance.nodes[node.id]
  end

  instance.remove_node = function(node)
    table.remove(instance.nodes, node.id)
  end

  instance.ger_root_nodes = function()
    return get_root_nodes(instance.nodes)
  end

  instance.find = function(query)
    return find_node(instance.nodes, query)
  end

  instance.tostring = function()
    local str = string.format("Graph: %s\n\n", instance.name)
    for i, node in pairs(instance.nodes) do
      str = str .. node.tostring() .. "\n -----------------\n"
    end
    return str
  end

  return instance
end

local graph = Graph("first")

local node1 =
  Node(
  {
    id = "1234",
    type = "TestNode",
    properties = {},
    links = {}
  }
)

local node2 =
  Node(
  {
    id = "2345",
    type = "TestNode",
    properties = {},
    links = {}
  }
)
local node3 =
  Node(
  {
    id = "3456",
    type = "TestNode",
    properties = {},
    links = {}
  }
)

graph.add_node(node1)
graph.add_node(node2)
graph.add_node(node3)

node1.to(node2, "Child")
node1.to(node3, "Child")

node3.to(node1, "Child")

-- print(graph.name)
print(graph.tostring())
-- print(node.tostring())
