local request =
  [[POST /jajaja HTTP/1.1
Content-Type: text/plain
User-Agent: PostmanRuntime/7.15.0
Accept: */*
Cache-Control: no-cache
Postman-Token: b8096f40-dbd4-4cf4-b0c6-a1f037884c02
Host: 192.168.43.183
accept-encoding: gzip, deflate
content-length: 91
Connection: keep-alive

{
  "email": "diego.torres+accr2@mango-soft.com",
  "eventId": "5ad7bf4c96a24200015d8078"
}]]

function forEach(items, callback)
  for index, item in pairs(items) do
    callback(item, index, items)
  end
end

function parceRequestString(reqStr)
  print("\n\n\n")
  print(reqStr)
  print("\n\n\n")
  local lines = getLines(reqStr)
  -- for i, line in pairs(lines) do
  --   print("\n\n" .. i .. "--------------\n")
  --   print(line)
  -- end
  function printItem(item, index)
    print("index:" .. index .. ", item: " .. item)
  end
  forEach(lines, printItem)
  local words = getWords(lines[1])
  -- print(words[1])
  -- print(words[2])
  -- print(words[3])
end

function getWords(str)
  chunks = {}
  for substring in str:gmatch("%S+") do
    table.insert(chunks, substring)
    -- print(substring)
  end
  return chunks
end

function getLines(str)
  lines = {}
  for s in str:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end
  return lines
end

parceRequestString(request)
