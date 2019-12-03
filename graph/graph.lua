local Graph = {}

-- //////////////////////////////////////////
-- GRAPH Class
-- //////////////////////////////////////////

Graph.get_root_nodes = function(nodes)
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

Graph.find_node = function(nodes, query)
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

Graph.create = function(name, template)
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
    return Graph.get_root_nodes(instance.nodes)
  end

  instance.find = function(query)
    return Graph.find_node(instance.nodes, query)
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

return Graph
