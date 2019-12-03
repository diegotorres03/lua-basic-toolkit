local Link = {}

Link.create = function(params)
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

return Link
