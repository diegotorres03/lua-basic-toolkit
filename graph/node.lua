function Node(params)
  local instance = {
    id = "",
    type = "",
    properties = {},
    links = {}
  }
  if (params) then
    instance.id = params.id
    instance.type = params.type
    instance.properties = params.properties
  end

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
end
