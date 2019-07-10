local Test = {}

local create_assert = function(assertMessages)
  local assertMessages = {}
  return function(expression, message)
    assertMessages[message] = expression
  end, assertMessages
end

Test.it = function(message, funct)
  local assert, assertMessages = create_assert()
  funct(assert)
  local success = true

  for message, valid in pairs(assertMessages) do
    success = success and valid
  end

  local res = ""
  if success then
    res = "^(*.*)^"
  else
    res = "(~+.+)~"
  end
  print(string.format("\n\n%s\t\t%s", res, message))
  for message, valid in pairs(assertMessages) do
    print("\t\t", valid and "" or "X", message)
  end
end

return Test
