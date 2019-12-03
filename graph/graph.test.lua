local Graph = require("./graph")
local Link = require("./link")
local Node = require("./node")

local graph = Graph.create("first")

local node1 =
  Node.create(
  {
    id = "1234",
    type = "TestNode",
    properties = {},
    links = {}
  }
)

local node2 =
  Node.create(
  {
    id = "2345",
    type = "TestNode",
    properties = {},
    links = {}
  }
)
local node3 =
  Node.create(
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
