QueueUtil = {}
function QueueUtil.new ()
    return {first = 0, last = -1}
end

function QueueUtil.pushleft (list, value)
    local first = list.first - 1
    list.first = first
    list[first] = value
end

function QueueUtil.pushright (list, value)
  local last = list.last + 1
  list.last = last
  list[last] = value
end

function QueueUtil.popleft (list)
  local first = list.first
  if first > list.last then error("list is empty") end
  local value = list[first]
  list[first] = nil        -- to allow garbage collection
  list.first = first + 1
  return value
end

function QueueUtil.popright (list)
  local last = list.last
  if list.first > last then error("list is empty") end
  local value = list[last]
  list[last] = nil         -- to allow garbage collection
  list.last = last - 1
  return value
end

function QueueUtil.isEmpty(list)
	return list.first > list.last
end

--- test
--[[
local queue = QueueUtil.new()
QueueUtil.pushright (queue, {info = "test1"})
QueueUtil.pushright (queue, {info = "test2"})
QueueUtil.pushright (queue, {info = "test3"})
local element = QueueUtil.popright (queue)
print (element.info)
local element = QueueUtil.popright (queue)
print (element.info)
local element = QueueUtil.popright (queue)
print (element.info)

print(tostring(QueueUtil.isEmpty(queue)))
--]]
